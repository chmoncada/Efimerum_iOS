//
//  PhotoWallModel.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 08/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import FirebaseDatabase

// MARK: PhotoWallModelType protocol
protocol PhotoWallModelType: class {
    
    // The tag query
    var labelQuery: String { get }
    
    var didLoad: () -> Void { get set }
    
    /// Called when volumes are inserted or removed
    var didUpdate: () -> Void { get set }
    
    // The number of photos in the list
    var numberOfPhotos: Int { get }
    
    // returns the photo at a given position
    func photo(at position: Int) -> Photo
    
}

// MARK: Class using Firebase Model
final class PhotoWallFirebaseModel: PhotoWallModelType {
    
    // MARK: Properties
    fileprivate let results: PhotoResultsType
    fileprivate let container: PhotoContainerType
    private let disposeBag = DisposeBag()
    
    // MARK: Init method
    init(labelQuery: String = "", container: PhotoContainerType = PhotoContainer.instance) {
        
        self.labelQuery = labelQuery
        //self.client = client
        self.container = container
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        results = container.allRandom(randomKey: getRandomKey())
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
        
        loadPhotos()
    }
    
    // MARK: PhotoWallModelType protocol implementation
    
    var labelQuery: String = ""
    var didLoad: () -> Void = {}
    var didUpdate: () -> Void = {}
    var numberOfPhotos: Int {
        return results.numberOfPhotos
    }
    
    func photo(at position: Int) -> Photo {
        return results.photo(at: position)
    }

    
}

// MARK: Util Methods
extension PhotoWallFirebaseModel {
    
    func loadPhotos()  {
        
        let container = self.container
        
        var ref: FIRDatabaseReference!
        var photos: [Photo] = []
        
        ref = FIRDatabase.database().reference()
        
        // First query random using some random order
        let observable = ref.child("photos").rx_observe(.childAdded)
        
        container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        let _ = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                
                if let dictionary = snap.value as? [String: Any] {
                    if let photo = PhotoResponse(json: dictionary) {
                        let key = snap.key
                        let photoToSave = Photo(identifier: key, photoResponse: photo)
                        photos.append(photoToSave)
                        let observable: Observable<Void>
                        observable = container.save(photos: [photoToSave])
                        observable.subscribe().addDisposableTo(DisposeBag())
                    }
                }
                
            })
    }
    
    
    
}





// TEST CLASS USING DEVICE CAROUSEL
//final class PhotoWallAssetsModel: PhotoWallModelType  {
//    
//    internal func loadPhotos() {
//        
//        //let container = self.container
//        
//        //let firebaseQuery = FIRDatabase.database().reference().child("photos").queryOrderedByKey()
//        
//    }
//    
//    
//    var labelQuery: String = ""
//    
//    var didLoad: () -> Void = {}
//    
//    internal func photo(at position: Int) -> Photo {
//        return PhotoContainer.instance.all().photo(at: position)
//    }
//    
//    
//    var didUpdate: () -> Void = {}
//    
//    var numberOfPhotos: Int {
//        
//        return allElementsFromLibrary().count
//        
//    }
//    
//    public func photoImage(at position: Int) -> UIImage {
//        
//        let asset = results[position]
//        var image = UIImage()
//        
//        let options = PHImageRequestOptions()
//        options.resizeMode = .fast
//        options.deliveryMode = .opportunistic
//        options.version = .current
//        options.isSynchronous = true
//        
//        PHCachingImageManager.default().requestImageData(for: asset,
//                                                         options: options) { (result, data, orientation, info) in
//                                                            image = UIImage(data: result!)!
//        }
//        
//        return image
//        
//    }
//    
//    private let results: PHFetchResult<PHAsset>
//    
//    init(results: PHFetchResult<PHAsset> = allElementsFromLibrary()) {
//        self.results = results
//        
//        //TEST
//        var ref: FIRDatabaseReference!
//        var photos: [Photo] = []
//        let container: PhotoContainerType = PhotoContainer.instance
//        
//        ref = FIRDatabase.database().reference()
//        
//        
//        let observable = ref.child("photos").rx_observe(.childAdded)
//        
//        container.deleteAll().subscribe().addDisposableTo(DisposeBag())
//        
//        let _ = observable.observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (snap) in
//                
//                if let dictionary = snap.value as? [String: Any] {
//                    if let photo = PhotoResponse(json: dictionary) {
//                        let key = snap.key
//                        let photoToSave = Photo(identifier: key, photoResponse: photo)
//                        photos.append(photoToSave)
//                        let observable: Observable<Void>
//                        observable = container.save(photos: [photoToSave])
//                        observable.subscribe().addDisposableTo(DisposeBag())
//                    }
//                }
//                
//            })
//        
//        
//        
//    }
//    
//}


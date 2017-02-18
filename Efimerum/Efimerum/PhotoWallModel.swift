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

// Represent a photo list model
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
    
    func photoImage(at position: Int) -> UIImage
    
    func load(nextPage trigger: Observable<Void>) -> Observable<Void>
}

// TEST CLASS USING DEVICE CAROUSEL
final class PhotoWallAssetsModel: PhotoWallModelType  {
    
    internal func load(nextPage trigger: Observable<Void>) -> Observable<Void> {
        //let container = self.container
        
        let firebaseQuery = FIRDatabase.database().reference().child("photos").queryOrderedByKey()
        
        return firebaseQuery.rx_observe(.childChanged)
            .map({ snapshot in
                print(snapshot)
                
            })
    }

    
    var labelQuery: String = ""
    
    var didLoad: () -> Void = {}
    
    internal func photo(at position: Int) -> Photo {
        return PhotoContainer.instance.all().photo(at: position)
    }

    
    var didUpdate: () -> Void = {}
    
    var numberOfPhotos: Int {
        
        return allElementsFromLibrary().count
        
    }
    
    public func photoImage(at position: Int) -> UIImage {
        
        let asset = results[position]
        var image = UIImage()
        
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.version = .current
        options.isSynchronous = true
        
        PHCachingImageManager.default().requestImageData(for: asset,
                                                         options: options) { (result, data, orientation, info) in
                                                            image = UIImage(data: result!)!
        }
        
        return image
        
    }
    
    private let results: PHFetchResult<PHAsset>
    
    init(results: PHFetchResult<PHAsset> = allElementsFromLibrary()) {
        self.results = results
        
        //TEST
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        //        ref.child("photos").observe(.childAdded, with: { (snapshot) in
        //            print(snapshot.value)
        //        })
        
        //        ref.child("photos").queryOrdered(byChild: "numOfLikes").queryLimited(toLast: 3).observe(.value) { (snap) in
        //            print("ORDENAMIENTO: \(snap.value)")
        //        }
        
//        ref.child("photos").queryOrdered(byChild: "numOfLikes").queryLimited(toLast: 3).observe(.value) { (snap) in
//            print(snap.value)
//        }
        
        let observable = ref.child("photos").queryOrdered(byChild: "numOfLikes").queryLimited(toLast: 3).rx_observe(.value)
        
        let _ = observable.subscribe(onNext: { (snap) in
            print(snap.value)
        })
        


    }
    
}

final class PhotoWallFirebaseModel: PhotoWallModelType {
    
    var labelQuery: String = ""
    var didLoad: () -> Void = {}
    
    // ÑAPA
    internal func photoImage(at position: Int) -> UIImage {
        let image = UIImage()
        return image
    }

    func load(nextPage trigger: Observable<Void>) -> Observable<Void> {
        return doLoad(page: 1, nextPage: trigger)
    }
    
    func photo(at position: Int) -> Photo {
        return results.photo(at: position)
    }

    
    var didUpdate: () -> Void = {}
    
    var numberOfPhotos: Int {
        return results.numberOfPhotos
    }
    
    private let results: PhotoResultsType
    private let client: ApiClient
    private let container: PhotoContainerType
    private let disposeBag = DisposeBag()
    
    init(client: ApiClient, labelQuery: String, container: PhotoContainerType = PhotoContainer.instance) {
        self.labelQuery = labelQuery
        self.client = client
        self.container = container

        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        results = container.all()
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
    }
    
    private func doLoad(page current: Int, nextPage trigger: Observable<Void>) -> Observable<Void> {
        
        let container = self.container
        
        let firebaseQuery = FIRDatabase.database().reference().child("photos").queryOrderedByKey()
        
        return firebaseQuery.rx_observe(.childChanged)
            .map({ snapshot in
                print(snapshot)
                
            })
        
        
        
//        return client.searchResults(forQuery: labelQuery, page: current)
//            .observeOn(MainScheduler.instance)
//            .flatMap { photos in
//                return container.save(photos: photos)
//            }
//            .flatMap { [unowned self] _ in
//                return Observable.concat([
//                    Observable.just(current),
//                    Observable.never().takeUntil(trigger),
//                    self.doLoad(page: (current + 1), nextPage: trigger)
//                    ])
//        }
    }
    
}

extension PhotoContainer {
    
    static let instance = PhotoContainer(name: "Comics")
    
}



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
import FirebaseAuth

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
    fileprivate var results: PhotoResultsType
    fileprivate let container: PhotoContainerType
    private let disposeBag = DisposeBag()
    
    // MARK: Init method
    
    init(labelQuery: String, container: PhotoContainerType, results: PhotoResultsType) {
        self.container = container
        self.results = results
        self.labelQuery = labelQuery
    }
    
    convenience init(labelQuery: String = "", container: PhotoContainerType = PhotoContainer.instance) {
        
        let data = container.allRandom(randomKey: getRandomKey())
        
        self.init(labelQuery: labelQuery, container: container, results: data)
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
        
        loadAllPhotos()
    }
    
    convenience init(sortedKey: String , container: PhotoContainerType = PhotoContainer.instance) {
        
        let data = container.sortedBy(sortedKey: sortedKey)
        
        self.init(labelQuery: sortedKey, container: container, results: data)
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
        
        //loadAllPhotos()
    }
    
    convenience init(name: String) {
        
        let container = PhotoContainer(name: name)
        
        let data = container.all()
        
        self.init(labelQuery: "", container: container, results: data)
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
        
        if name == "UserPhotos" {
            loadUserPhotos()
        } else if name == "LikesPhotos" {
            loadLikesPhotos()
        }
        
        
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
    
    func loadAllPhotos()  {
        
        let container = self.container
        
        var ref: FIRDatabaseReference!
        var photos: [Photo] = []
        var photosToEdit: [Photo] = []
        
        ref = FIRDatabase.database().reference()
        
        // First query random using some random order
        let observable = ref.child("photos").rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photos").rx_observe(.childChanged)
        
        container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        let _ = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    for child in snap.children {
                        let photoSnap = child as! FIRDataSnapshot
                        if let dictionary = photoSnap.value as? [String: Any] {
                            if let photo = PhotoResponse(json: dictionary) {
                                let key = photoSnap.key
                                let photoToSave = Photo(identifier: key, photoResponse: photo)
                                photos.append(photoToSave)
                                
                            }
                        }
                    }
                    let observable2: Observable<Void>
                    observable2 = container.save(photos: photos)
                    observable2.subscribe().addDisposableTo(DisposeBag())
                }
            })
        
        let _ = modifyObservable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    let dict = snap.value as? [String: Any]
                    let photo = PhotoResponse(json: dict!)
                    let key = snap.key
                    let photoToEdit = Photo(identifier: key, photoResponse: photo!)
                    photosToEdit.append(photoToEdit)       
                }
                let observable3: Observable<Void>
                observable3 = container.edit(photos: photosToEdit)
                observable3.subscribe().addDisposableTo(DisposeBag())
                
            })
        
    }
    
    func loadUserPhotos()  {
        
        let container = self.container
        
        var ref: FIRDatabaseReference!
        var photos: [Photo] = []
        var photosToEdit: [Photo] = []
        
        ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosPostedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosPostedByUser").child(uid!).rx_observe(.childChanged)
        
        container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        let _ = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    for child in snap.children {
                        let photoSnap = child as! FIRDataSnapshot
                        if let dictionary = photoSnap.value as? [String: Any] {
                            if let photo = PhotoResponse(json: dictionary) {
                                let key = photoSnap.key
                                let photoToSave = Photo(identifier: key, photoResponse: photo)
                                photos.append(photoToSave)
                                
                            }
                        }
                    }
                    let observable2: Observable<Void>
                    observable2 = container.save(photos: photos)
                    observable2.subscribe().addDisposableTo(DisposeBag())
                }
            })
        
        let _ = modifyObservable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    let dict = snap.value as? [String: Any]
                    let photo = PhotoResponse(json: dict!)
                    let key = snap.key
                    let photoToEdit = Photo(identifier: key, photoResponse: photo!)
                    photosToEdit.append(photoToEdit)   
                }
                let observable3: Observable<Void>
                observable3 = container.edit(photos: photosToEdit)
                observable3.subscribe().addDisposableTo(DisposeBag())
                
            })
        
    }
    
    func loadLikesPhotos()  {
        
        let container = self.container
        
        var ref: FIRDatabaseReference!
        var photos: [Photo] = []
        var photosToEdit: [Photo] = []
        
        ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosLikedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosLikedByUser").child(uid!).rx_observe(.childChanged)
        
        container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        let _ = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    for child in snap.children {
                        let photoSnap = child as! FIRDataSnapshot
                        if let dictionary = photoSnap.value as? [String: Any] {
                            if let photo = PhotoResponse(json: dictionary) {
                                let key = photoSnap.key
                                let photoToSave = Photo(identifier: key, photoResponse: photo)
                                photos.append(photoToSave)
                                
                            }
                        }
                    }
                    let observable2: Observable<Void>
                    observable2 = container.save(photos: photos)
                    observable2.subscribe().addDisposableTo(DisposeBag())
                }
            })
        
        let _ = modifyObservable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    print(snap)
                    let dict = snap.value as? [String: Any]
                    let photo = PhotoResponse(json: dict!)
                    let key = snap.key
                    let photoToEdit = Photo(identifier: key, photoResponse: photo!)
                    photosToEdit.append(photoToEdit)
                }
                let observable3: Observable<Void>
                observable3 = container.edit(photos: photosToEdit)
                observable3.subscribe().addDisposableTo(DisposeBag())
                
            })
        
    }
    
}

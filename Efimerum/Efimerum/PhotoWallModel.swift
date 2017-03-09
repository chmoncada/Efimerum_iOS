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
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
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
        
        loadPhotosWithTag(labelQuery)
        
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
    
    func loadPhotosWithTag(_ tag: String)  {
        
        let ref = FIRDatabase.database().reference()
        
        var observable: Observable<FIRDataSnapshot>
        var modifyObservable: Observable<FIRDataSnapshot>
        
        if tag == "" {
            observable = ref.child("photos").rx_observeSingleEvent(of: .value)
            modifyObservable = ref.child("photos").rx_observe(.childChanged)
        } else {
            observable = ref.child("photosByLabel").child("EN").child(labelQuery.lowercased()).rx_observeSingleEvent(of: .value)
            modifyObservable = ref.child("photosByLabel").child("EN").child(labelQuery.lowercased()).rx_observe(.childChanged)
        }
        
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container)
    }
    
    func loadUserPhotos()  {
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosPostedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosPostedByUser").child(uid!).rx_observe(.childChanged)
        
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container)
        
    }
    
    func loadLikesPhotos()  {
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosLikedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosLikedByUser").child(uid!).rx_observe(.childChanged)
        
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container)
    }
}

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
    fileprivate var disposeBag = DisposeBag()
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    lazy var userLocationManager: UserLocationManager = {
        let manager = UserLocationManager()
        return manager
    }()
    
    // MARK: Init method
    
    init(labelQuery: String, container: PhotoContainerType, results: PhotoResultsType) {
        self.container = container
        self.results = results
        self.labelQuery = labelQuery
    }
    
    convenience init(labelQuery: String = "", sortedBy sortedKey: FilterType = .random, container: PhotoContainerType = PhotoContainer.instance) {
        
        var data: PhotoResultsType
        
        
        switch sortedKey {
        case .mostVoted:
            data = container.sortedBy(sortedKey: "numOfLikes", ascending: false)
        case .lessLife:
            data = container.sortedBy(sortedKey: "expirationDate", ascending: true)
        case .mostLife:
            data = container.sortedBy(sortedKey: "expirationDate", ascending: false)
        case .nearest:
            
            
            data = container.all()
        case .random:
            data = container.allRandom(randomKey: getRandomKey())
        }

        self.init(labelQuery: labelQuery, container: container, results: data)
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
        
        loadPhotos(withTag: labelQuery, sortedBy: sortedKey)
        
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
    
    func loadPhotos(withTag tag: String = "", sortedBy filter: FilterType = .random ) {
        
        let ref = FIRDatabase.database().reference()
        
        var rootRef: FIRDatabaseReference
        
        var totalRef : FIRDatabaseQuery
        
        var geoQueryRef: GFCircleQuery?
        
        var observable: Observable<FIRDataSnapshot>
        var modifyObservable: Observable<FIRDataSnapshot>
        
        if tag == "" {
            rootRef = ref.child("photos")
        } else {
            rootRef = ref.child("photosByLabel").child("EN").child(labelQuery.lowercased())
        }
        
        switch filter {
        case .mostVoted:
            totalRef = rootRef.queryOrdered(byChild: "numOfLikes")
        case .lessLife, .mostLife:
            totalRef = rootRef.queryOrdered(byChild: "expirationDate")
        case .random, .nearest:
            totalRef = rootRef
        }
 
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        if filter != .nearest {
            observable = totalRef.rx_observeSingleEvent(of: .value)
            modifyObservable = totalRef.rx_observe(.childChanged)
            
            databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container).addDisposableTo(disposeBag)
            
        } else {
            
            let when = DispatchTime.now() + 2
            userLocationManager.locationManager.startUpdatingLocation()
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                geoQueryRef = self.circleQuery(self.userLocationManager, ref: rootRef)
                guard let geofireObservable = geoQueryRef?.rx_observeEvent(of: .keyEntered) else {
                    return
                }
                let modifyObservable = ref.child("photos").rx_observe(.childChanged)
                
                self.databaseManager.setupGeoObservable(observable: geofireObservable, inContainer: self.container).addDisposableTo(self.disposeBag)
                
                self.databaseManager.setupGeoObservableChanges(observable: modifyObservable, inContainer: self.container).addDisposableTo(self.disposeBag)
                
                self.userLocationManager.locationManager.stopUpdatingLocation()
            }
            
        }
   
    }
    
    func circleQuery(_ userLocationManager: UserLocationManager?, ref: FIRDatabaseReference) -> GFCircleQuery? {

        let geoFire = GeoFire(firebaseRef: ref)
        
        guard let location = userLocationManager?.currentLocation else {
            return nil
        }
  
        let circleQuery = geoFire?.query(at: location, withRadius: 1)
        
        return circleQuery
    }
    
    func loadUserPhotos()  {
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosPostedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosPostedByUser").child(uid!).rx_observe(.childChanged)
        
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container).addDisposableTo(disposeBag)
        
    }
    
    func loadLikesPhotos()  {
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let observable = ref.child("photosLikedByUser").child(uid!).rx_observeSingleEvent(of: .value)
        let modifyObservable = ref.child("photosLikedByUser").child(uid!).rx_observe(.childChanged)
        
        self.container.deleteAll().subscribe().addDisposableTo(DisposeBag())
        
        databaseManager.setupObservables(observable: observable, modifyObservable: modifyObservable, inContainer: self.container).addDisposableTo(disposeBag)
    }
}


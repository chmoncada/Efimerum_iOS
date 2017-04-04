//
//  FirebaseDatabaseManager.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseDatabase

import RxSwift
import Realm

class FirebaseDatabaseManager {
    
    private init() {}
    
    public static func Instance() -> FirebaseDatabaseManager {
        return instance
    }
    
    static let instance: FirebaseDatabaseManager = FirebaseDatabaseManager()
    let ref = FIRDatabase.database().reference()
    
    func getUserDataForUserWithUID(_ uid: String, completion: @escaping (_ name: String?, _ email: String?, _ imageURL: URL?) -> Void) {
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
            if let dictionary = snap.value as? [String: Any] {
                
                let email = dictionary["email"] as! String
                guard let name = dictionary["name"] as? String, let imageURLString = dictionary["profileImageURL"] as? String else {
                    completion(nil, email, nil)
                    return
                }
                let imageURL = URL(string: imageURLString)
                
                completion(name, email, imageURL)
            }
        })
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: Any],completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                completion(false, err)
                return
            }
            
            completion(true, nil)
            
        })
    }
    
    func getTagsWith(query q: String, completion: @escaping (_ tags: [String]?) -> Void) {
        
        ref.child("labels").child("EN").queryOrderedByKey().queryStarting(atValue: q.lowercased()).queryEnding(atValue: "\(q.lowercased())\("uf8ff")").observeSingleEvent(of: .value, with: { (snap) in
            if let dict = snap.value as? [String: Any] {
                let tagsFound = Array(dict.keys)
                let tagsOrdered = tagsFound.sorted{ $0 < $1 }
                completion(tagsOrdered)
            } else {
                completion(nil)
            }
        })
        
    }
    
    func getPhotoWIth(identifier: String, completion: @escaping (_ photo: Photo?) -> Void) {
        
        ref.child("photos").queryOrderedByKey().queryEqual(toValue: identifier).queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: { (snap) in
            if snap.exists() {
                for child in snap.children {
                    let dict = child as! FIRDataSnapshot
                    if let dictionary = dict.value as? [String: Any] {
                        if let photo = PhotoResponse(json: dictionary) {
                            let key = snap.key
                            let photoToSHow = Photo(identifier: key, photoResponse: photo)
                            completion(photoToSHow)
                        }
                    }
                }
            }
        })
        
    }
    
    func setupObservables(observable: Observable<FIRDataSnapshot>, modifyObservable: Observable<FIRDataSnapshot>, inContainer container: PhotoContainerType) -> Disposable {
        
        var photos: [Photo] = []
        var photosToEdit: [Photo] = []
        
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
                    //photos = photos.reversed()
                    observable2 = container.save(photos: photos)
                    observable2.subscribe().addDisposableTo(DisposeBag())
                }
            })
        
        let disposable = modifyObservable.observeOn(MainScheduler.instance)
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
        
        return disposable
    }

    func setupGeoObservable(observable: Observable<String>, inContainer container: PhotoContainerType) -> Disposable {
        
        //var photos: [Photo] = []
        var photoToSave: Photo?
        //var photosToEdit: [Photo] = []
        
        let disposable = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (key) in
                self.ref.child("photos").queryOrderedByKey().queryEqual(toValue: key).observeSingleEvent(of: .value, with: { (snap) in
                    if snap.exists() {
                        for child in snap.children {
                            let photoSnap = child as! FIRDataSnapshot
                            if let dictionary = photoSnap.value as? [String: Any] {
                                if let photo = PhotoResponse(json: dictionary) {
                                    let key = photoSnap.key
                                    photoToSave = Photo(identifier: key, photoResponse: photo)
                                }
                            }
                        }
                    }
                    let observable2: Observable<Void>
                    observable2 = container.save(photos: [photoToSave!])
                    observable2.subscribe().addDisposableTo(DisposeBag())
                })
            })
        
        return disposable
    }
    
    func setupGeoObservableChanges(observable: Observable<FIRDataSnapshot>, inContainer container: PhotoContainerType) -> Disposable {
        
        var photosToEdit: [Photo] = []
        
        let disposable = observable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (snap) in
                if snap.exists() {
                    let dict = snap.value as? [String: Any]
                    let photo = PhotoResponse(json: dict!)
                    let key = snap.key
                    let photoToEdit = Photo(identifier: key, photoResponse: photo!)
                    photosToEdit.append(photoToEdit)
                }
                let observable3: Observable<Void>
                observable3 = container.editIfExist(photos: photosToEdit)
                observable3.subscribe().addDisposableTo(DisposeBag())
                
            })
        
        return disposable    
    }
    
}


//                ref.child("labels").child("EN").queryOrderedByKey().queryStarting(atValue: "b").queryEnding(atValue: "c").observeSingleEvent(of: .value, with: { (snap) in
//                    print(snap)
//                })

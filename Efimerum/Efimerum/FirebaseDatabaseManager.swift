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
    
    func getUserDataForUserWithUID(_ uid: String, completion: @escaping (_ name: String?, _ email: String?, _ imageURL: URL?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
            if let dictionary = snap.value as? [String: Any] {
                let name = dictionary["name"] as! String
                let email = dictionary["email"] as! String
                let imageURLString = dictionary["profileImageURL"] as! String
                let imageURL = URL(string: imageURLString)
                
                completion(name, email, imageURL)
            }
        })
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: Any],completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                completion(false, err)
                return
            }
            
            completion(true, nil)
            
        })
    }
    
    func setupObservables(observable: Observable<FIRDataSnapshot>, modifyObservable: Observable<FIRDataSnapshot>, inContainer container: PhotoContainerType) {
        
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

    
}

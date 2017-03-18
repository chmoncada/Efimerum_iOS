//
//  ModifyUserInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import  FirebaseDatabase
import FirebaseStorage
import PKHUD

protocol ModifyUserInteractorInput {
    
    func getDataFromUser()
    func updateUserInfo(withNewName newName: String?, newImage: UIImage?, completion: @escaping (Bool) -> Void)
}

protocol ModifyUserInteractorOutput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

class ModifyUserInteractor: ModifyUserInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    var output: ModifyUserInteractorOutput!
    
    func getDataFromUser() {
        authManager.getUserUID { (uid) in
            if let uid = uid {
                databaseManager.getUserDataForUserWithUID(uid) { name, email, imageURL in
                    if let name = name, let email = email {
                        self.output.bindViewWithName(name, email: email, imageURL: imageURL)
                    }
                }
            }
        }
    }
    
    func updateUserInfo(withNewName newName: String?, newImage: UIImage?, completion: @escaping (Bool) -> Void) {
        
        authManager.getUserUID { (uid) in
            
            guard let uid = uid else {
                return
            }
            
            let fcmToken = FirebaseMessagingManager.Instance().getFcmToken()!
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = newImage, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        HUD.flash(.label(error.localizedDescription), delay: 1)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        
                        var values: [String : Any]
                        
                        if let newName = newName {
                            values = ["name": newName, "profileImageURL": profileImageURL, "fcmToken": fcmToken]
                        } else {
                            values = ["profileImageURL": profileImageURL]
                        }
                        
                        
                        self.databaseManager.registerUserIntoDatabaseWithUID(uid, values: values, completion: { (success, err) in
                            if let err = err {
                                HUD.flash(.label(err.localizedDescription), delay: 1)
                                return
                            }
                            HUD.flash(.success, delay: 1.0)
                            completion(success)
                        })
                    }
                    
                })
            } else {
                print("no ha cambiado foto, lo subire vacio")
                var values: [String : Any] = [:]
                if let newName = newName {
                   values = ["name": newName, "fcmToken": fcmToken]
                }
                
                self.databaseManager.registerUserIntoDatabaseWithUID(uid, values: values, completion: { (success, err) in
                    if let err = err {
                        HUD.flash(.label(err.localizedDescription), delay: 1)
                        return
                    }
                    HUD.flash(.success, delay: 1.0)
                    completion(success)
                })
            }
            
        }
        
    }
    
}

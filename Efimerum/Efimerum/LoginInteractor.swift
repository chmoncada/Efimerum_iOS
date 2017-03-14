//
//  LoginInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 03/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseStorage

protocol LoginInteractorInput {
    func sendPasswordReset(_ viewcontroller: UIViewController)
    func login(withEmail email: String, password: String, inViewController: UIViewController, completion: @escaping (_ success: Bool) -> Void)
    func register(withEmail email: String, password: String, name: String, image: UIImage?, completion: @escaping (Bool) -> Void)
}


class LoginInteractor: LoginInteractorInput {
    
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    func sendPasswordReset(_ viewcontroller: UIViewController) {
        
        let alert = UIAlertController(title: "Reset Password", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            
            let email = (alert.textFields![0] as UITextField).text!
            print(email)
            HUD.show(.label("Sending recovery email.."))
            
            self?.authManager.sendPasswordReset(email: email, handleCompletion: { (error) in
                if let error = error {
                    HUD.flash(.label(error.localizedDescription), delay: 2)
                    return
                }
                HUD.flash(.success, delay: 2.0)
            })
            
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email"
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewcontroller.present(alert, animated: true, completion: nil)
        
    }
    
    func login(withEmail email: String, password: String, inViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        
        authManager.login(withEmail: email, password: password) { (error) in
            if error != nil {
                HUD.flash(.label("The credentials are wrong, try again"), delay: 1)
                return completion(false)
            }
            
            HUD.flash(.success, delay: 1.0)
            return completion(true)
        }
    }
    
    func register(withEmail email: String, password: String, name: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        if let _ = authManager.isAnonymous() {
            
            authManager.linkAccount(withEmail: email, password: password, handleCompletion: { (uid, error) in
                
                if error != nil {
                    HUD.flash(.label(error?.localizedDescription), delay: 1)
                    return
                }
                
                self.registerUserIntoFirebase(uid, withName: name, email: email, image: image) { success in
                    completion(success)
                }
            })
        }
    }
    
    func registerUserIntoFirebase(_ uid: String?, withName name: String, email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        
        guard let uid = uid else {
            return
        }
        
        // Success
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        
        if let profileImage = image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    HUD.flash(.label(error?.localizedDescription), delay: 1)
                    return
                }
                
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                    
                    self.databaseManager.registerUserIntoDatabaseWithUID(uid, values: values, completion: { (success, err) in
                        if err != nil {
                            HUD.flash(.label(err?.localizedDescription), delay: 1)
                            return
                        }
                        HUD.flash(.success, delay: 1.0)
                        completion(success)
                    })
                    
                }
                
            })
        } else {
            print("no tiene foto, lo subire vacio")
            let values = ["name": name, "email": email]
            self.databaseManager.registerUserIntoDatabaseWithUID(uid, values: values, completion: { (success, err) in
                if err != nil {
                    HUD.flash(.label(err?.localizedDescription), delay: 1)
                    return
                }
                HUD.flash(.success, delay: 1.0)
                completion(success)
            })
        }
        
    }
    

    
}

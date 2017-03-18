//
//  FirebaseManager.swift
//  Efimerum
//
//  Created by Charles Moncada on 24/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol FireBaseManagerLogoutOutput: class {
    func userDidLogout(success: Bool)
    func userLoginAnonymous(success: Bool)
}

protocol AuthenticationManagerType {
    func logout()
    func loginAnonymous()
    func getTokenForUser(completion: @escaping (_ token: String?) -> Void)
    func sendPasswordReset(email: String, handleCompletion: @escaping (_ error: Error?) -> Void)
    func login(withEmail email: String, password: String, handleCompletion: @escaping (_ error: Error?) -> Void)
}

class FirebaseAuthenticationManager {
    
    var output: FireBaseManagerLogoutOutput!
    
    private init() {}
    
    public static func Instance() -> FirebaseAuthenticationManager {
        return instance
    }
    
    static let instance: FirebaseAuthenticationManager = FirebaseAuthenticationManager()
        
    func setupLoginListener() {
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                if (user?.isAnonymous)! {
                    print("soy anonimo")
                } else {
                    print("soy usuario logeado")
                }
            } else {
                print("alguien se deslogeo del servicio, deberias logearte anonimo")
                if self.output != nil {
                    self.output.userDidLogout(success: true)
                } else {
                    print("primera vez corriendo la app")
                }
            
            }
            
        })
    }
    
}

extension FirebaseAuthenticationManager: AuthenticationManagerType {
    
    func logout() {
        
        if let oldUser = FIRAuth.auth()?.currentUser {
            
            if (oldUser.isAnonymous) {
                print("soy anonimo, no me voy a desloguear, gracias")
            } else {
                do {
                    
                    let values = ["fcmToken": ""]
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        FirebaseDatabaseManager.Instance().registerUserIntoDatabaseWithUID(uid, values: values, completion: { (success, err) in
                            if err != nil {
                                return
                            }
                            print(success)
                        })
                    }
                    
                    try FIRAuth.auth()?.signOut()
                } catch let logoutError {
                    print(logoutError)
                }
            }
        }
        
    }
    
    func loginAnonymous() {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            self.output.userLoginAnonymous(success: true)
        })
    }
    
    func isNotAuthenticated() -> Bool {
        return FIRAuth.auth()?.currentUser?.uid == nil || (FIRAuth.auth()?.currentUser?.isAnonymous)!
    }
    
    func isAnonymous() -> Bool? {
        return FIRAuth.auth()?.currentUser?.isAnonymous
    }
    
    func linkAccount(withEmail email: String, password: String, handleCompletion: @escaping (_ uid: String?, _ error: Error?) -> Void) {
        
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
        
        FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
            if let uid = user?.uid {
                handleCompletion(uid, error)
                return
            }
            
            handleCompletion(nil, error)
        })
        
    }
    
    func getTokenForUser(completion: @escaping (_ token: String?) -> Void) {
        let currentUser = FIRAuth.auth()?.currentUser
        currentUser?.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
                // Handle error
                print(error)
                completion(nil)
                return;
            }
            
           completion(idToken)
            
        }
    }
    
    func sendPasswordReset(email: String, handleCompletion: @escaping (_ error: Error?) -> Void) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            
            if let error = error {
                handleCompletion(error)
                return
            }
            
            handleCompletion(nil)
        })
        
    }
    
    func login(withEmail email: String, password: String, handleCompletion: @escaping (_ error: Error?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                handleCompletion(error)
                return
            }
            
            handleCompletion(nil)
            
        })
        
    }
    
    func getUserUID(completion: (_ uid: String?) -> Void) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        completion(uid)
    }
}

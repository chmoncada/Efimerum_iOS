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
                self.output.userDidLogout(success: true)
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
                    print("me deslogueare")
                    try FIRAuth.auth()?.signOut()
                } catch let logoutError {
                    print(logoutError)
                }
            }
        }
        
    }
    
    func loginAnonymous() {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            print("logeado anonimo con exito")
            self.output.userLoginAnonymous(success: true)
        })
    }
}

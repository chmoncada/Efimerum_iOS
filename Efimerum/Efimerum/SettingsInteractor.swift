//
//  SettingsInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol SettingsInteractorInput {
    
    func getDataFromUser()
}

protocol SettingsInteractorOutput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

class SettingsInteractor: SettingsInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    var output: SettingsInteractorOutput!
    
    func getDataFromUser() {
        authManager.getUserUID { (uid) in
            if let uid = uid {
                let ref = FIRDatabase.database().reference()
                ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
                    if let dictionary = snap.value as? [String: Any] {
                        let name = dictionary["name"] as! String
                        let email = dictionary["email"] as! String
                        let imageURLString = dictionary["profileImageURL"] as! String
                        let imageURL = URL(string: imageURLString)
                        
                        self.output.bindViewWithName(name, email: email, imageURL: imageURL)
                        
                    }
                })
            }
        }
    }
    
}

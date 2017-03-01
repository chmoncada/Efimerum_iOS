//
//  SettingsInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol ProfileInteractorInput {
    
    func getDataFromUser()
}

protocol ProfileInteractorOutput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

class ProfileInteractor: ProfileInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    var output: ProfileInteractorOutput!
    
    func getDataFromUser() {
        authManager.getUserUID { (uid) in
            if let uid = uid {
                databaseManager.getUserDataForUserWithUID(uid) { name, email, imageURL in
                    if let name = name, let email = email, let imageURL = imageURL {
                        self.output.bindViewWithName(name, email: email, imageURL: imageURL)
                    }
                }
            }
        }
    }
    
}

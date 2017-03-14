//
//  AuthInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 03/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol AuthInteractorInput {
    func isNotAuthenticated() -> Bool
}

class AuthInteractor: AuthInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    private init() {}
    
    public static func Instance() -> AuthInteractor {
        return instance
    }
    
    static let instance: AuthInteractor = AuthInteractor()
    
    func isNotAuthenticated() -> Bool {
        return authManager.isNotAuthenticated()
    }
    
    func logout() {
        authManager.logout()
    }
    
}

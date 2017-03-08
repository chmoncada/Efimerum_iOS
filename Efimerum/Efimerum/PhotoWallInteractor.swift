//
//  PhotoWallInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol PhotoWallInteractorInput {
    func isNotAuthenticated() -> Bool
}

class PhotoWallInteractor: PhotoWallInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    func isNotAuthenticated() -> Bool {
        return authManager.isNotAuthenticated()
    }
}

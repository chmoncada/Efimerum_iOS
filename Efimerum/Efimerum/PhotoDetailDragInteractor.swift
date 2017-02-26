//
//  PhotoDetailDragInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 25/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol PhotoDetailDragInteractorInput {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
    func isNotAuthenticated() -> Bool
    func likeToPhotoWithIdentifier(_ identifier: String)
}

class PhotoDetailDragInteractor: PhotoDetailDragInteractorInput {
    
    internal func likeToPhotoWithIdentifier(_ identifier: String) {
        print("FUNCIONALIDAD DE LIKE PHOTO: \(identifier)")
    }


    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    internal func deletePhotosOfIndexes(_ indexes: [String]) {
        RxSwiftManager.deletePhotosOfIndexes(indexes)
    }

    func logout() {
        authManager.logout()
    }
    
    func isNotAuthenticated() -> Bool {
        return authManager.isNotAuthenticated()
    }

    func loginAnonymous() {
        authManager.loginAnonymous()
    }

    func userDidLogout(success: Bool) {
        if success {
            loginAnonymous()
        }
    }
    
    func userLoginAnonymous(success: Bool) {
        print("el usuario se logeo anonimo: \(success)")
    }
    
}

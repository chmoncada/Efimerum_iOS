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
    
    func likeToPhotoWithIdentifier(_ identifier: String) {
        
        authManager.getTokenForUser() { token in
            if let idToken = token {
                
                ApiClient.likePhoto(token: idToken, photoKey: identifier, latitude: 41.375, longitude: 2.1706, completion: { (result) in
                    print(result)
                })
                
            }
        }
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

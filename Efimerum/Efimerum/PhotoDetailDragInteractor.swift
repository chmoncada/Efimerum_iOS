//
//  PhotoDetailDragInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 25/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import CoreLocation

protocol PhotoDetailDragInteractorInput {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
    func likeToPhotoWithIdentifier(_ identifier: String, location: CLLocation?)
}

class PhotoDetailDragInteractor: PhotoDetailDragInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()

    
    func likeToPhotoWithIdentifier(_ identifier: String, location: CLLocation?) {
        
        authManager.getTokenForUser() { token in
            if let idToken = token {
                
                ApiClient.likePhoto(token: idToken, photoKey: identifier, latitude: location?.coordinate.latitude, longitude: location?.coordinate.longitude, completion: { (result) in
                    print(result)
                })
            }
        }
    }

    internal func deletePhotosOfIndexes(_ indexes: [String]) {
        RxSwiftManager.deletePhotosOfIndexes(indexes)
    }

    
}


// TODO: Cleaning, temporal, it should be go to profile settings scene
extension PhotoDetailDragInteractor {
    
    func logout() {
        authManager.logout()
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

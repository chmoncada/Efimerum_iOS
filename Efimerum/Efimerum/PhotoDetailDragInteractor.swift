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



//
//  PhotoDetailDragInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 25/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import CoreLocation
import PKHUD

protocol PhotoDetailDragInteractorInput {
    func deletePhotosOfIndexes( _ indexes: [String])
    func likeToPhotoWithIdentifier(_ identifier: String, location: CLLocation?)
    func reporPhotoWith(identifier: String, code: String)
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
    
    func reporPhotoWith(identifier: String, code: String) {
        
        authManager.getTokenForUser { (token) in
            if let idToken = token {
                
                HUD.show(.label("Reporting photo..."))
                ApiClient.reportPhoto(token: idToken, photoKey: identifier, reportCode: code, completion: { (success, error) in
                    if success {
                        print("Photo with ID: \(identifier) was reported")
                        HUD.flash(.success, delay: 1.0)
                    } else {
                        print(error!)
                        HUD.flash(.error, delay: 1.0)
                    }
                })
            }
        }
    }

    
}



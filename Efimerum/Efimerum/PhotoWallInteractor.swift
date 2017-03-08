//
//  PhotoWallInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol PhotoWallInteractorInput {
    func postPhotoWithImageData(_ imageData: Data, withLocationManager userlocationManager: UserLocationManager?)
}

class PhotoWallInteractor: PhotoWallInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    func postPhotoWithImageData(_ imageData: Data, withLocationManager userlocationManager: UserLocationManager?) {
        
        authManager.getTokenForUser { (idToken) in
            guard let token = idToken else {
                return
            }
            
            let location = userlocationManager?.currentLocation
            var latitude :Double?
            var longitude :Double?
            
            if let lat = location?.coordinate.latitude,
                let lon = location?.coordinate.longitude {
                
                print("latitude: \(lat) - longitude: \(lon)")
                latitude = Double(lat)
                longitude = Double(lon)
            }
            userlocationManager?.locationManager.stopUpdatingLocation()
            
            ApiClient.postPhoto(photoData: imageData, token: token, latitude: latitude, longitude: longitude, completion: { (result) in
                print(result)
            })
        }
        
        
    }
}

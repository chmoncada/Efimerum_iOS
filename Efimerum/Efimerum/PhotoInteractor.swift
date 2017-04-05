//
//  PhotoInteractor.swift
//  Efimerum
//
//  Created by Michel on 17/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol PhotoInteractorInput :class {
    
    func postPhotoWithImageData(_ imageData: Data, withLocationManager userlocationManager: UserLocationManager?)
    
}

protocol PhotoInteractorOutput : class {
    
    func showLoading()
    func dismissLoadingFailed()
    func dismissLoadingSuccess()
}

class PhotoInteractor :PhotoInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    weak fileprivate var interface :PhotoInteractorOutput?
    
    init(interface: PhotoInteractorOutput) {
        
        self.interface = interface
    }
    
    
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
            
            self.interface?.showLoading()
            
            ApiClient.postPhoto(photoData: imageData, token: token, latitude: latitude, longitude: longitude, completion: { (result) in
                print(result)
                
                if let error = result.error {
                    print("error posting a Photo: \(error)")
                    self.interface?.dismissLoadingFailed()
                } else {
                    self.interface?.dismissLoadingSuccess()
                }
                
            })
        }
    }
}

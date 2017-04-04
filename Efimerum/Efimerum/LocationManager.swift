//
//  LocationManager.swift
//  Efimerum
//
//  Created by Michel on 01/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import MapKit


protocol UserLocationManagerProtocol : class {
    
    func locationDidUpdateToLocation(location: CLLocation, manager: UserLocationManager)
    
}


class UserLocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var currentLocation :CLLocation?
    
    var delegate : UserLocationManagerProtocol?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    //MARK: - CLLocationManagerDelegate
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
 
//        print("latitude: \(currentLocation?.coordinate.latitude) - longitude: \(currentLocation?.coordinate.longitude)")
        
        DispatchQueue.main.async {
            self.delegate?.locationDidUpdateToLocation(location: self.currentLocation!, manager: self)
        }
    }
    
}

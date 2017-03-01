//
//  LocationManager.swift
//  Efimerum
//
//  Created by Michel on 01/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import MapKit


protocol LocationManagerProtocol : class {
    
    func locationDidUpdateToLocation(location: CLLocation, manager: LocationManager)
    
}


class LocationManager : NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    
    var currentLocation :CLLocation?
    
    var delegate : LocationManagerProtocol?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation
       
        DispatchQueue.main.async {
            self.delegate?.locationDidUpdateToLocation(location: self.currentLocation!, manager: self)
        }
       
    }
    
}

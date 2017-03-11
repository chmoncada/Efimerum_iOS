//
//  FirebaseDatabase+RX.swift
//  Efimerum
//
//  Created by Charles Moncada on 17/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift
import GeoFire

extension FIRDatabaseQuery {
    
    func rx_observe(_ eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            let handle = self.observe(eventType, with: observer.onNext, withCancel: observer.onError)
            return Disposables.create {
                self.removeObserver(withHandle: handle)
            }
        }
    }
    
    func rx_observeSingleEvent(of eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            self.observeSingleEvent(of: eventType, with: { (snapshot) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: observer.onError)
            
            return Disposables.create()
        }
    }
    
    func rx_observeEvent(of eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            self.observe(eventType, with: { (snapshot) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: observer.onError)
            
            return Disposables.create()
        }
    }
    
}

extension GFQuery {
    
    func rx_observeEvent(of eventType: GFEventType) -> Observable<String> {
        
        return Observable.create { observer in
            self.observe(eventType, with: { (key, location) in
                observer.onNext(key!)

            })
            return Disposables.create()
        }
        
    }
    
}

//
//  FirebaseMessagingManager.swift
//  Efimerum
//
//  Created by Charles Moncada on 18/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseMessaging
import FirebaseInstanceID

class FirebaseMessagingManager {
    
    private init() {}
    
    public static func Instance() -> FirebaseMessagingManager {
        return instance
    }
    
    private static let instance: FirebaseMessagingManager = FirebaseMessagingManager()

    func connect() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
                print(InstanceID.instanceID().token()!)
            }
        }
    }
    
    func disconnect() {
        Messaging.messaging().disconnect()
    }
    
    func getFcmToken() -> String? {
        
        var returnToken: String?
        
        if let token = InstanceID.instanceID().token() {
            returnToken = token
        } else {
            Messaging.messaging().connect(handler: { (error) in
                if error != nil {
                    print("Unable to connect with FCM. \(error)")
                } else {
                    print("Connected to FCM.")
                    print(InstanceID.instanceID().token()!)
                    if let token = InstanceID.instanceID().token() {
                        returnToken = token
                    }
                }
            })
        }
        return returnToken
    }
    
}

//
//  FirebaseDatabaseManager.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseDatabaseManager {
    
    private init() {}
    
    public static func Instance() -> FirebaseDatabaseManager {
        return instance
    }
    
    static let instance: FirebaseDatabaseManager = FirebaseDatabaseManager()
    
    func getUserDataForUserWithUID(_ uid: String, completion: @escaping (_ name: String?, _ email: String?, _ imageURL: URL?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
            if let dictionary = snap.value as? [String: Any] {
                let name = dictionary["name"] as! String
                let email = dictionary["email"] as! String
                let imageURLString = dictionary["profileImageURL"] as! String
                let imageURL = URL(string: imageURLString)
                
                completion(name, email, imageURL)
            }
        })
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: Any],completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                completion(false, err)
                return
            }
            
            completion(true, nil)
            
        })
    }
    
}

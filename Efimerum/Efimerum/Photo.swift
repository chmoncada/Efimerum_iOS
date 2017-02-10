//
//  Photo.swift
//  Efimerum
//
//  Created by Charles Moncada on 09/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

/// A efimerum photo object
struct Photo {
    
    /// Unique identifier
    let identifier: String
    
    /// creation date
    let creationDate: Date
    
    /// originator user
    let userName: String
    
    /// photo coordinates
    let longitude: Float
    let latitude: Float
    
    /// number of Likes
    let likes: Int
    
    /// photo URL
    let photoURL: URL
    
    /// photo Tags?
    let tags: Array<String>
    
    init(identifier: String, creationDate: Date, userName: String, longitude: Float, latitude: Float, likes: Int, photoURL: URL, tags: Array<String>) {
        self.identifier = identifier
        self.creationDate = creationDate
        self.userName = userName
        self.longitude = longitude
        self.latitude = latitude
        self.likes = likes
        self.photoURL = photoURL
        self.tags = tags
    }
    
}

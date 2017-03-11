//
//  Photo.swift
//  Efimerum
//
//  Created by Charles Moncada on 09/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

/// A efimerum photo object
public struct Photo {
    
    /// Unique identifier
    let identifier: String
    
    /// Sorting index
    let index: String
    
    /// originator user
    let authorID: String
    
    /// creation date
    let creationDate: Double
    
    /// expiration date
    let expirationDate: Double
    
    /// photo coordinates
    let longitude: Float
    let latitude: Float
    
    /// number of Likes
    let numOfLikes: Double
    
    /// random keys
    let md5: String
    let randomString: String
    let sha1: String
    let sha256: String
    
    let imageWidth: Double
    let imageHeight: Double
    let imageURL: URL
    
    let thumbnailWidth: Double
    let thumbnailHeight: Double
    let thumbnailURL: URL
    
    /// photo Tags?
    let tags: Array<String>
    
    init(identifier: String, index: String, creationDate: Double, expirationDate: Double, authorID: String, longitude: Float, latitude: Float, numOfLikes: Double, imageWidth: Double, imageHeight: Double, imageURL: URL, thumbnailWidth: Double, thumbnailHeight: Double, thumbnailURL: URL, tags: Array<String>, md5: String, randomString: String, sha1: String, sha256: String) {
        self.identifier = identifier
        self.index = index
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.authorID = authorID
        self.longitude = longitude
        self.latitude = latitude
        self.numOfLikes = numOfLikes
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.imageURL = imageURL
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.thumbnailURL = thumbnailURL
        
        self.md5 = md5
        self.randomString = randomString
        self.sha1 = sha1
        self.sha256 = sha256
        
        self.tags = tags
    }
    
}

extension Photo {
    
    internal init(entry: PhotoEntry) {
        
        self.identifier = entry.identifier
        self.index = entry.index
        self.creationDate = entry.creationDate
        self.expirationDate = entry.expirationDate
        self.authorID = entry.authorID
        self.longitude = entry.longitude
        self.latitude = entry.latitude
        self.numOfLikes = entry.numOfLikes
        self.imageWidth = entry.imageWidth
        self.imageHeight = entry.imageHeight
        self.imageURL = entry.stringToURL(entry.imageURLString)!
        self.thumbnailWidth = entry.thumbnailWidth
        self.thumbnailHeight = entry.thumbnailHeight
        self.thumbnailURL = entry.stringToURL(entry.thumbnailURLString)!
        self.md5 = entry.md5
        self.randomString = entry.randomString
        self.sha1 = entry.sha1
        self.sha256 = entry.sha256
        
        var tags: [String] = []
        for tag in entry.labels_ES {
            tags.append(tag.tag)
        }
        self.tags = tags
    }
    
    init(identifier: String, photoResponse: PhotoResponse) {
        self.identifier = identifier
        self.index = photoResponse.md5
        self.creationDate = photoResponse.creationDate
        self.expirationDate = photoResponse.expirationDate
        self.authorID = photoResponse.owner
        self.numOfLikes = photoResponse.numOfLikes
        self.imageWidth = photoResponse.imageData.width
        self.imageHeight = photoResponse.imageData.height
        self.imageURL = photoResponse.imageData.url
        self.thumbnailWidth = photoResponse.thumbnailData.width
        self.thumbnailHeight = photoResponse.thumbnailData.height
        self.thumbnailURL = photoResponse.thumbnailData.url
        self.md5 = photoResponse.md5
        self.randomString = photoResponse.randomString
        self.sha1 = photoResponse.sha1
        self.sha256 = photoResponse.sha256
        
        if let latitude = photoResponse.latitude, let longitude = photoResponse.longitude {
            self.latitude = latitude
            self.longitude = longitude
        } else {
            self.latitude = 0
            self.longitude = 0
        }
        
        let tags: [String] = []
        self.tags = tags
    }
    
}

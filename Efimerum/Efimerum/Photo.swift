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
    let index: Int
    
    /// originator user
    let authorID: String
    
    /// creation date
    let creationDate: Date
    
    /// expiration date
    let expirationDate: Date
    
    /// photo coordinates
    let longitude: Float
    let latitude: Float
    
    /// number of Likes
    let numOfLikes: Int
    
    let imageWidth: Float
    let imageHeight: Float
    let imageURL: URL
    
    let thumbnailWidth: Float
    let thumbnailHeight: Float
    let thumbnailURL: URL
    
    /// photo Tags?
    let tags: Array<String>
    
    init(identifier: String, index: Int, creationDate: Date, expirationDate: Date, authorID: String, longitude: Float, latitude: Float, numOfLikes: Int, imageWidth: Float, imageHeight: Float, imageURL: URL, thumbnailWidth: Float, thumbnailHeight: Float, thumbnailURL: URL, tags: Array<String>) {
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
        
        var tags: [String] = []
        for tag in entry.labels_ES {
            tags.append(tag.tag)
        }
        self.tags = tags
    }
    
}

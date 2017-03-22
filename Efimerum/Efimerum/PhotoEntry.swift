//
//  PhotoEntry.swift
//  Efimerum
//
//  Created by Charles Moncada on 14/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import RealmSwift


class PhotoEntry: Object {
   
    dynamic var identifier = ""
    
    dynamic var index = ""
    dynamic var authorID: String = ""
    dynamic var creationDate: Double = 0
    dynamic var expirationDate: Double = 0
    
    dynamic var latitude: Float = 0
    dynamic var longitude: Float = 0
    
    dynamic var numOfLikes:Double = 0
    
    dynamic var imageWidth: Double = 0
    dynamic var imageHeight: Double = 0
    dynamic var imageURLString: String = ""
    
    dynamic var thumbnailWidth: Double = 0
    dynamic var thumbnailHeight: Double = 0
    dynamic var thumbnailURLString: String = ""
    
    dynamic var dynamicLink: String = ""
    
    dynamic var md5: String = ""
    dynamic var randomString: String = ""
    dynamic var sha1: String = ""
    dynamic var sha256: String = ""
    
    let labels_EN = List<Tags>()
    let labels_ES = List<Tags>()
    
    
    func stringToURL(_ url: String?) -> URL? {
        return url.flatMap { URL(string: $0)}
    }

    override static func primaryKey() -> String? {
        return "identifier"
    }
    
}

extension PhotoEntry {
    
    convenience init(photo: Photo) {
        self.init()
        identifier = photo.identifier
        index = photo.index
        authorID = photo.authorID
        creationDate = photo.creationDate
        expirationDate = photo.expirationDate
        longitude = photo.longitude
        latitude = photo.latitude
        numOfLikes = photo.numOfLikes
        imageWidth = photo.imageWidth
        imageHeight = photo.imageHeight
        imageURLString = photo.imageURL.absoluteString
        thumbnailHeight = photo.thumbnailHeight
        thumbnailWidth = photo.thumbnailWidth
        thumbnailURLString = photo.thumbnailURL.absoluteString
        md5 = photo.md5
        randomString = photo.randomString
        sha1 = photo.sha1
        sha256 = photo.sha256
        dynamicLink = photo.dynamicLink
        
        for tag in photo.tags {
            let myTag = Tags()
            myTag.tag = tag
            labels_EN.append(myTag)
        }
        
        for tag in photo.tags {
            let myTag = Tags()
            myTag.tag = tag
            labels_ES.append(myTag)
        }
        
    }
}

class Tags: Object {
    dynamic var tag = ""
}

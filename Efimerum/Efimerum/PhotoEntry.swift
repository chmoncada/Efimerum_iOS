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
    
    dynamic var index: Int = 0
    dynamic var authorID: String = ""
    dynamic var creationDate = Date()
    dynamic var expirationDate = Date()
    
    dynamic var latitude: Float = 0
    dynamic var longitude: Float = 0
    
    dynamic var numOfLikes:Int = 0
    
    dynamic var imageWidth: Float = 0
    dynamic var imageHeight: Float = 0
    dynamic var imageURLString: String = ""
    
    dynamic var thumbnailWidth: Float = 0
    dynamic var thumbnailHeight: Float = 0
    dynamic var thumbnailURLString: String = ""
    
    let labels_EN = List<Tags>()
    let labels_ES = List<Tags>()
    
    
    func stringToURL(_ url: String?) -> URL? {
        return url.flatMap { URL(string: $0)}
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
        thumbnailWidth = photo.thumbnailHeight
        thumbnailURLString = photo.thumbnailURL.absoluteString
        
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

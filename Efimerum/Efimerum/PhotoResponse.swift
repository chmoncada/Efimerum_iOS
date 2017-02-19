//
//  PhotoResponse.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 17/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Gloss


struct PhotoResponse :Decodable {
    
    let creationDate :Double
    let expirationDate :Double
    let latitude :Float?
    let longitude :Float?
    let md5 :String
    let numOfLikes :Double
    //let numOfViews :Double
    let owner :String
    let randomString :String
    let sha1 :String
    let sha256 :String
    
    let imageData :PictureData
    let thumbnailData :PictureData
    
    
    init?(json: JSON) {
        
        guard let creationDate: Double = "creationDate" <~~ json else {
            return nil
        }
        guard let expirationDate: Double = "expirationDate" <~~ json else {
            return nil
        }
        
        guard let md5: String = "md5" <~~ json else {
            return nil
        }
        guard let numOfLikes: Double = "numOfLikes" <~~ json else {
            return nil
        }
//        guard let numOfViews: Double = "numOfViews" <~~ json else {
//            return nil
//        }
        guard let owner: String = "owner" <~~ json else {
            return nil
        }
        guard let randomString: String = "randomString" <~~ json else {
            return nil
        }
        guard let sha1: String = "sha1" <~~ json else {
            return nil
        }
        guard let sha256: String = "sha256" <~~ json else {
            return nil
        }
        
        guard let imageData: PictureData = "imageData" <~~ json else {
            return nil
        }
        guard let thumbnailData: PictureData = "thumbnailData" <~~ json else {
            return nil
        }
        

        
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.latitude = "latitude" <~~ json
        self.longitude = "longitude" <~~ json
        self.md5 = md5
        self.numOfLikes = numOfLikes
        //self.numOfViews = numOfViews
        self.owner = owner
        self.randomString = randomString
        self.sha1 = sha1
        self.sha256 = sha256
        
        self.imageData = imageData
        self.thumbnailData = thumbnailData

    }
}


struct PictureData :Decodable {
    
    let height :Double
    let width :Double
    let url :URL
    
    init?(json: JSON) {
    
        guard let height: Double = "height" <~~ json else {
            return nil
        }
        guard let width: Double = "width" <~~ json else {
            return nil
        }
        guard let urlString: String = "url" <~~ json else {
            return nil
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        self.height = height
        self.width = width
        self.url = url
    }
}


struct PhotoLabels :Decodable {
    
    
    
    init?(json: JSON) {
        
    }
}



































//
//  PhotoWallModel.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 08/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import Photos

// Represent a photo list model
protocol PhotoWallModelType: class {
    
    // The number of photos in the list
    var numberOfPhotos: Int { get }
    
    // returns the photo at a given position
    func photo(at position: Int) -> UIImage
}

// TEST CLASS USING DEVICE CAROUSEL
final class PhotoWallAssetsModel: PhotoWallModelType {
    
    var numberOfPhotos: Int {
        
        return allElementsFromLibrary().count
        
    }
    
    func photo(at position: Int) -> UIImage {
        
        let asset = results[position]
        var image = UIImage()
        
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.version = .current
        options.isSynchronous = true
        
        PHCachingImageManager.default().requestImageData(for: asset,
                                                         options: options) { (result, data, orientation, info) in
                                                            image = UIImage(data: result!)!
        }
        
        return image
        
    }
    
    private let results: PHFetchResult<PHAsset>
    
    init(results: PHFetchResult<PHAsset> = allElementsFromLibrary()) {
        self.results = results
    }
    
}


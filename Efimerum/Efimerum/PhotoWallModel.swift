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
    
    /// Called when volumes are inserted or removed
    var didUpdate: () -> Void { get set }
    
    // The number of photos in the list
    var numberOfPhotos: Int { get }
    
    // returns the photo at a given position
    func photo(at position: Int) -> Photo
    
    func photoImage(at position: Int) -> UIImage
}

// TEST CLASS USING DEVICE CAROUSEL
final class PhotoWallAssetsModel: PhotoWallModelType {
    
    internal func photo(at position: Int) -> Photo {
        return PhotoContainer.instance.all().photo(at: position)
    }

    
    var didUpdate: () -> Void = {}
    
    var numberOfPhotos: Int {
        
        return allElementsFromLibrary().count
        
    }
    
    public func photoImage(at position: Int) -> UIImage {
        
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

final class PhotoWallFirebaseModel: PhotoWallModelType {
    
    // ÑAPA
    internal func photoImage(at position: Int) -> UIImage {
        let image = UIImage()
        return image
    }

    
    func photo(at position: Int) -> Photo {
        return results.photo(at: position)
    }

    
    var didUpdate: () -> Void = {}
    
    var numberOfPhotos: Int {
        return results.numberOfPhotos
    }
    
    private let results: PhotoResultsType
    
    init(results: PhotoResultsType = PhotoContainer.instance.all()) {
        self.results = results
        
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
    }
    
}

extension PhotoContainer {
    
    static let instance = PhotoContainer(name: "Comics")
    
}

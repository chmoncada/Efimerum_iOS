//
//  Photos.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 05/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import Photos
import Foundation
    
    func allElementsFromLibrary() -> PHFetchResult<PHAsset> {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    

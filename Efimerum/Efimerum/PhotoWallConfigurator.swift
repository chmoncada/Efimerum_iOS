//
//  PhotoWallConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

//extension AuthInteractor : PhotoWallViewControllerAuthOutput {}

class PhotoWallConfigurator {
    private init() {}
    
    public static func Instance() -> PhotoWallConfigurator {
        return instance
    }
    
    static let instance: PhotoWallConfigurator = PhotoWallConfigurator()
    
    func configure(viewController: PhotoWallViewController) {

        
    }
}

//
//  PhotoWallViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension PhotoWallViewController {
    
    func handleTakePhoto() {
        
        if self.authInteractor.isNotAuthenticated() {
            print("me apretaron a ver si funciona esto en la vista photowall")
            needAuthLogin()
        } else {
            takePicture()
        }
        
    }
    
}

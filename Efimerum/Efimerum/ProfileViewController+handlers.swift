//
//  ProfileViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension ProfileViewController {
    
    func handleDismissView() {
        
        let _ = navigationController?.popViewController(animated: false)
    }
    
    func handleSettingsButton() {
        didSelectSettings()
    }
    
    func handleCollectionChange(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            model = PhotoWallFirebaseModel(name: "UserPhotos")
            
        } else {
            model = PhotoWallFirebaseModel(name: "LikesPhotos")
            
        }
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.collectionViewSizeCalculator.clearCache()
        
        setupBindings()
    }
    
}

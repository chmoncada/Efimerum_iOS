//
//  PhotoWallViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension PhotoWallViewController {
    
    func setupBindings() {
        // Reload our collection view when the model changes
        model?.didUpdate = { [weak self] in
            
            self?.reloadGrid()
        }
        
    }
    
    func setupFloatButtons(scroll: UIScrollView){
        
        let settingsButton = MBFloatScrollButton(buttonType: .profile, on: scroll, for: self.view)
        settingsButton.delegate = self
        
        orderByButton = MBFloatScrollButton(buttonType: .orderBy, on: scroll, for: self.view)
        orderByButton.delegate = self
        
        let cameraButton = MBFloatScrollButton(buttonType: .camera, on: scroll, for: self.view)
        cameraButton.delegate = self
        
        searchButton = MBFloatScrollButton(buttonType: .search, on: scroll, for: self.view)
        searchButton.delegate = self
        
        let logoButton = MBFloatScrollButton(buttonType: .logo, on: scroll, for: self.view)
        logoButton.delegate = self
    }
    
    func setupLayout() {
        
        self.layout.minimumInteritemSpacing = 1
        self.layout.minimumLineSpacing = 1
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

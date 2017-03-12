//
//  PhotoDetailInfoViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 11/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension PhotoDetailInfoViewController {
    
    func handleDismissView() {
        
        didFinish()
    }
    
    func handleTap() {
        closeButton.isHidden = !closeButton.isHidden
    }
}

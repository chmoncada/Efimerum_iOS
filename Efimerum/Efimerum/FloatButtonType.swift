//
//  FloatButtonType.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 21/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import UIKit


enum FloatButtonType {
    
    case camera
    case search
    case orderBy
    case profile
    case logo
    
    
}


struct FloatButton {
    
    let image : UIImage
    let text : String
    let parentView : UIView
    
    init(image: UIImage, text: String, parentView: UIView) {
        self.image = image
        self.text = text
        self.parentView = parentView
    }
}

//
//  UIImage+Rotation.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 20/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}

//
//  CustomKolodaView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit


//let defaultTopOffset: CGFloat = 20
let defaultHorizontalOffset: CGFloat = 20
let defaultHeightRatio: CGFloat = 1.3
let backgroundCardHorizontalMarginMultiplier: CGFloat = 0.25
let backgroundCardScalePercent: CGFloat = 1.5

class CustomKolodaView: KolodaView {

    override func frameForCard(at index: Int) -> CGRect {

            //let topOffset: CGFloat = defaultTopOffset
            let xOffset: CGFloat = defaultHorizontalOffset
            let width = (self.frame).width - 2 * defaultHorizontalOffset
            let height = width * defaultHeightRatio
            let yOffset: CGFloat = (self.frame.height - height) / 2
            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        
            return frame
       
        
    }

}

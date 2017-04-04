//
//  FilterType.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 12/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import UIKit


enum FilterType {

    case nearest
    case mostLife
    case lessLife
    case mostVoted
    case random
    
    func getFilterObject() -> FilterObject {
        
        switch self {
        case .nearest:
            return FilterObject(image: UIImage(named: "plus")!, text: "Nearest")
        case .mostLife:
            return FilterObject(image: UIImage(named: "plus")!, text: "More life")
        case .lessLife:
            return FilterObject(image: UIImage(named: "plus")!, text: "About to die")
        case .mostVoted:
            return FilterObject(image: UIImage(named: "plus")!, text: "Most Liked")
        default:
            return FilterObject(image: UIImage(named: "plus")!, text: "Random")
        }
    }
    
    func getImage() -> UIImage {
        
        var f : FilterObject
        
        switch self {
        case .nearest:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Nearest")
        case .mostLife:
            f = FilterObject(image: UIImage(named: "plus")!, text: "More life")
        case .lessLife:
            f = FilterObject(image: UIImage(named: "plus")!, text: "About to die")
        case .mostVoted:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Most Liked")
        default:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Random")
        }
        return f.image
    }
    
    func getText() -> String {
        
        var f : FilterObject
        
        switch self {
        case .nearest:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Nearest")
        case .mostLife:
            f = FilterObject(image: UIImage(named: "plus")!, text: "More life")
        case .lessLife:
            f = FilterObject(image: UIImage(named: "plus")!, text: "About to die")
        case .mostVoted:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Most Liked")
        default:
            f = FilterObject(image: UIImage(named: "plus")!, text: "Random")
        }
        return f.text
    }
    
    

}

struct FilterObject {
    
    let image : UIImage
    let text : String
    
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
    }
}

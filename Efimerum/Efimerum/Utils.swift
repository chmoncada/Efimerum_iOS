//
//  Utils.swift
//  Efimerum
//
//  Created by Charles Moncada on 19/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

func getRandomKey() -> String {
    
    var randomKey = ""
    let random = Int(arc4random_uniform(4))
    switch random {
    case 0:
        randomKey = "md5"
    case 1:
        randomKey = "randomString"
    case 2:
        randomKey = "sha1"
    case 3:
        randomKey = "sha256"
    default:
        randomKey = "randomString"
    }
    
    return randomKey
}

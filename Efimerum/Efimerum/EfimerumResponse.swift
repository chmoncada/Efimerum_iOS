//
//  EfimerumResponse.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 15/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Gloss

struct EfimerumResponse :Decodable {
    let success :Bool
    let data :String?
    let error: String?
   
    init?(json: JSON) {
        
        guard let success: Bool = "success" <~~ json else {
            return nil
        }
        self.success = success
        self.data = "data" <~~ json
        self.error = "error" <~~ json
    }
}

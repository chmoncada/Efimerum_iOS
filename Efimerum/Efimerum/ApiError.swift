//
//  ApiError.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 15/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation


enum ApiError :Error {
    case serverError(message: String)
    case unknownError
    case parserError
}

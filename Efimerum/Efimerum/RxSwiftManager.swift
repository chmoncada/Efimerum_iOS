//
//  RxSwiftManager.swift
//  Efimerum
//
//  Created by Charles Moncada on 26/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import RxSwift

class RxSwiftManager {
    
    static func deletePhotosOfIndexes(_ indexes: [String]) {
        let container = PhotoContainer.instance
        let observable: Observable<Void>
        observable = container.delete(photosWithIdentifiers: indexes)
        observable.subscribe().addDisposableTo(DisposeBag())
    }
    
}

//
//  PhotoDetailDragInteractor.swift
//  Efimerum
//
//  Created by Charles Moncada on 25/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoDetailDragInteractorInput {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
}

class PhotoDetailDragInteractor: PhotoDetailDragInteractorInput {
    
    var manager: FirebaseManager = {
        let manager = FirebaseManager.Instance()
        manager.setupLoginListener()
        return manager
    }()
    
    internal func deletePhotosOfIndexes(_ indexes: [String]) {
        let container = PhotoContainer.instance
        let observable: Observable<Void>
        observable = container.delete(photosWithIdentifiers: indexes)
        observable.subscribe().addDisposableTo(DisposeBag())
    }

    
    func logout() {
        
        manager.output = self
        manager.logout()
    }

    func userDidLogout(success: Bool) {
        print("el usuario se deslogeo del Firebase: \(success)")
    }
    
}

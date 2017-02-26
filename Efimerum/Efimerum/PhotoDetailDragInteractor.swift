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
    func loginAnonymous()
}

class PhotoDetailDragInteractor: PhotoDetailDragInteractorInput {
    
    var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.Instance()
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
        authManager.logout()
    }
    
    func loginAnonymous() {
        authManager.loginAnonymous()
    }

    func userDidLogout(success: Bool) {
        print("el usuario se deslogeo del Firebase: \(success)")
        if success {
            loginAnonymous()
        }
    }
    
    func userLoginAnonymous(success: Bool) {
        print("el usuario se logeo anonimo: \(success)")
    }
    
}

//
//  PhotoDetailDragConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 25/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension PhotoDetailDragInteractor: PhotoDetailDragViewControllerOutput {}
extension PhotoDetailDragInteractor : FireBaseManagerLogoutOutput {}

class PhotoDetailDragConfigurator {
    
    private init() {}
    
    public static func Instance() -> PhotoDetailDragConfigurator {
        return instance
    }
    
    static let instance: PhotoDetailDragConfigurator = PhotoDetailDragConfigurator()
    
    func configure(viewController: PhotoDetailDragViewController) {
        
        let interactor = PhotoDetailDragInteractor()
        
        //let authInteractor = AuthInteractor.instance
        
        interactor.authManager.output = interactor
        
        viewController.output = interactor

    }
    
}

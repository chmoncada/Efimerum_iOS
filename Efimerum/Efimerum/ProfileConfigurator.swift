//
//  SettingsConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension ProfileInteractor: ProfileViewControllerOutput {}

extension ProfileViewController : ProfileInteractorOutput {}

class ProfileConfigurator {
    
    private init() {}
    
    public static func Instance() -> ProfileConfigurator {
        return instance
    }
    
    static let instance: ProfileConfigurator = ProfileConfigurator()
    
    func configure(viewController: ProfileViewController) {
        
        let interactor = ProfileInteractor()
        
        viewController.output = interactor
        
        interactor.output = viewController
        
    }
    
}

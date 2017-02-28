//
//  SettingsConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension SettingsInteractor: SettingsViewControllerOutput {}

extension SettingsViewController : SettingsInteractorOutput {}

class SettingsConfigurator {
    
    private init() {}
    
    public static func Instance() -> SettingsConfigurator {
        return instance
    }
    
    static let instance: SettingsConfigurator = SettingsConfigurator()
    
    func configure(viewController: SettingsViewController) {
        
        let interactor = SettingsInteractor()
        
        //interactor.authManager.output = interactor
        
        viewController.output = interactor
        
        interactor.output = viewController
        
    }
    
}

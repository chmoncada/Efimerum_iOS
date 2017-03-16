//
//  ModifyUserConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension ModifyUserInteractor: ModifyUserViewControllerOutput {}

extension ModifyUserViewController : ModifyUserInteractorOutput {}


class ModifyUserConfigurator {
    
    private init() {}
    
    public static func Instance() -> ModifyUserConfigurator {
        return instance
    }
    
    static let instance: ModifyUserConfigurator = ModifyUserConfigurator()
    
    func configure(viewController: ModifyUserViewController) {
        
        let interactor = ModifyUserInteractor()
        
        viewController.output = interactor
        
        interactor.output = viewController
        
    }
    
}

//
//  LoginConfigurator.swift
//  Efimerum
//
//  Created by Charles Moncada on 03/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension LoginInteractor: LoginViewControllerOutput {}

class LoginConfigurator {
    
    private init() {}
    
    public static func Instance() -> LoginConfigurator {
        return instance
    }
    
    static let instance: LoginConfigurator = LoginConfigurator()
    
    func configure(viewController: LoginViewController) {
        
        let interactor = LoginInteractor()
        
        viewController.output = interactor
        
    }
    
}


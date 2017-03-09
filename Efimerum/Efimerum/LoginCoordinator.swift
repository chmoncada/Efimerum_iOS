//
//  LoginCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 09/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: LoginViewController
    
    var action: () -> Void = {}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = LoginViewController()
        
        super.init()
        
        viewController.didFinish = { [weak self] success in
            guard let `self` = self else {
                return
            }
            
//            if success {
//                self.action()
//            }
            
            // This will remove the coordinator from its parent
            self.navigationController.dismiss(animated: true) { _ in
                if success {
                  self.action()
                }
            }
            
            self.didFinish()
        }
        
   
    }
    
    override func start() {
        navigationController.definesPresentationContext = true
//        navigationController.pushViewController(viewController, animated: true)
        
       //Present modally
        navigationController.present(viewController, animated: true, completion: nil)
        
    }
    
}





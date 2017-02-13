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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = LoginViewController()
        
        super.init()
        
        viewController.didFinish = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            self.navigationController.dismiss(animated: true, completion: nil
            )
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


//private unowned let navigationController: UINavigationController
//private let viewController: LoginViewController
//
//init(navigationController: UINavigationController) {
//    self.navigationController = navigationController
//    self.viewController = LoginViewController()
//    
//    super.init()
//    
//    viewController.didFinish = { [weak self] in
//        guard let `self` = self else {
//            return
//        }
//        
//        // This will remove the coordinator from its parent
//        self.didFinish()
//    }
//    
//    
//}
//
//override func start() {
//    navigationController.definesPresentationContext = true
//    navigationController.pushViewController(viewController, animated: true)
//}



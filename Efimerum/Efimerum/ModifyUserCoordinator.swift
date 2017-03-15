//
//  ModifyUserCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

final class ModifyUserCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: ModifyUserViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = ModifyUserViewController()
        
        super.init()
        
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

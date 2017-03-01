//
//  SettingsCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: ProfileViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = ProfileViewController()
        
        super.init()
        
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

//
//  UserSettingsCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

import UIKit

final class UserSettingCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: UserSettingsViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = UserSettingsViewController(style: .grouped)
        
        super.init()
        
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

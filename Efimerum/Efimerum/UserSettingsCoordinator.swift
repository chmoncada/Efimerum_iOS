//
//  UserSettingsCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

final class UserSettingCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: UserSettingsViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = UserSettingsViewController(style: .grouped)
        
        super.init()
        
        
        viewController.didMoveFromParent = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            self.didFinish()
            
        }
        
        viewController.goToModifyUser = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = ModifyUserCoordinator(navigationController: navigationController)
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

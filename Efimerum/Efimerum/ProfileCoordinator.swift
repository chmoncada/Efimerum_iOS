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
        
        viewController.didSelectPhoto = { [weak self] photoIdentifier in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = SinglePhotoDetailCoordinator(navigationController: navigationController, identifier: photoIdentifier)
            
            
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
        viewController.didSelectSettings = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = UserSettingCoordinator(navigationController: navigationController)
            
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
        }
        
        viewController.didMoveFromParent = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            self.didFinish()
            
        }
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

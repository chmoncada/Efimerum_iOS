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
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

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
    var closeIt: () -> Void = {}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = UserSettingsViewController(style: .grouped)
        
        super.init()
        
        viewController.didFinish = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            //self.navigationController.dismiss(animated: true)
            let _ = self.navigationController.popViewController(animated: false)
            self.closeIt()
            self.didFinish()
        }
        
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

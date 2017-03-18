//
//  SinglePhotoDetailCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

final class SinglePhotoDetailCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: SinglePhotoDetailViewController
    private let identifier: String
    
    init(navigationController: UINavigationController, identifier: String) {
        self.navigationController = navigationController
        self.identifier = identifier
        self.viewController = SinglePhotoDetailViewController(identifier: identifier)
        
        super.init()
        
        viewController.didAskPhotoInfo = { [weak self] photo in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = PhotoDetailInfoCoordinator(navigationController: navigationController, photo: photo)
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

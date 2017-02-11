//
//  PhotoWallCoordinator.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 08/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit

final class PhotoWallCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: PhotoWallViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = PhotoWallViewController(model: PhotoWallAssetsModel())
        
        super.init()
        
        viewController.didSelectPhoto = { [weak self] index in
            guard let strongSelf = self else {
                return
            }

            let coordinator = PhotoDetailDragCoordinator(navigationController: navigationController)
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

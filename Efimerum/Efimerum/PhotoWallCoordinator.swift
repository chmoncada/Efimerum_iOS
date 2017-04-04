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
    var coordinator: Coordinator?
    
    var photoIdentifier: String? {
        didSet {
            viewController.didShowSinglePhoto(photoIdentifier!)
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewController = PhotoWallViewController()
        
        super.init()
        
        viewController.didShowSinglePhoto = { [weak self] photoIdentifier in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = SinglePhotoDetailCoordinator(navigationController: navigationController, identifier: photoIdentifier)
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
        viewController.didSelectPhoto = { [weak self] model, startIndex in
            guard let strongSelf = self else {
                return
            }

            strongSelf.coordinator = PhotoDetailDragCoordinator(navigationController: navigationController, model: model, startIndex: startIndex)
            
            strongSelf.add(child: strongSelf.coordinator!)
            
            strongSelf.coordinator?.start()
            
        }
        
        viewController.goToProfile = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = ProfileCoordinator(navigationController: navigationController)
            
            strongSelf.add(child: coordinator)
            
            coordinator.start()
            
        }
        
        viewController.needAuthLogin = { [weak self]  scene in
            guard let strongSelf = self else {
                return
            }
            
            let coordinator = LoginCoordinator(navigationController: navigationController)
            strongSelf.add(child: coordinator)
            
            coordinator.action = {
                print("termine de logearme ahora anda a donde necesites")
                
                if scene == "profile" {
                    strongSelf.viewController.goToProfile()
                } else if scene == "takePhoto" {
                    strongSelf.viewController.takePicture()
                }
                
            }
            
            coordinator.start()
        }
    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

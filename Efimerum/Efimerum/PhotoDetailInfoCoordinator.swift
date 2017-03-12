//
//  PhotoDetailInfoCoordinator.swift
//  Efimerum
//
//  Created by Charles Moncada on 11/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

final class PhotoDetailInfoCoordinator: Coordinator {
    
    private unowned let navigationController: UINavigationController
    private let viewController: PhotoDetailInfoViewController
    private var identifier : String
    
    
    init(navigationController: UINavigationController, identifier: String) {
        self.navigationController = navigationController
        self.identifier = identifier
        self.viewController = PhotoDetailInfoViewController(identifier: identifier)
        
        super.init()
        
        viewController.didFinish = { [weak self] in
            guard let `self` = self else {
                return
            }
            
            // This will remove the coordinator from its parent
            self.navigationController.dismiss(animated: true)
            self.didFinish()
        }


    }
    
    override func start() {
        viewController.definesPresentationContext = true
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
}


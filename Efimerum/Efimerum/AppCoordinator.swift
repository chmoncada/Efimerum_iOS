//
//  AppCoordinator.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 29/09/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        
        customizeAppearance()
        
        window.rootViewController = navigationController

        let coordinator = PhotoWallCoordinator(navigationController: navigationController)

        add(child: coordinator)
        coordinator.start()

        window.makeKeyAndVisible()
    }

    private func customizeAppearance() {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//        let navigationBarAppearance = UINavigationBar.appearance()
//        let barTintColor = UIColor.black
//
//        navigationBarAppearance.barStyle = .black // This will make the status bar white by default
//        navigationBarAppearance.barTintColor = barTintColor
//        navigationBarAppearance.tintColor = UIColor.white
//        navigationBarAppearance.titleTextAttributes = [
//            NSForegroundColorAttributeName: UIColor.white
//        ]
    }
}

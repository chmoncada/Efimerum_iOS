//
//  AppDelegate.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 28/01/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        
//        let _ = ApiClient.request(endpoint: .photos) { (result) in
//            print(result)
//        }
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if (FIRAuth.auth()?.currentUser) == nil {
            
            
            FIRAuth.auth()?.signInAnonymously(completion: { [weak self] (user, error) in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.coordinator = AppCoordinator(window: window)
                strongSelf.coordinator?.start()
                
            })

        } else {
            
            
            coordinator = AppCoordinator(window: window)
            coordinator?.start()
        }
        
        return true
    }


}


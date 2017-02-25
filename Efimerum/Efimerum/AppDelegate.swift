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

import FirebaseDatabase
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        //FirebaseManager().setupLoginListener()
        
        
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
            
//            let currentUser = FIRAuth.auth()?.currentUser
//            currentUser?.getTokenForcingRefresh(true) {idToken, error in
//                if let error = error {
//                    // Handle error
//                    return;
//                }
//                
//                print(idToken)
//            }
            
            coordinator = AppCoordinator(window: window)
            coordinator?.start()
        }
        
        return true
    }

    internal func load() -> Observable<FIRDataSnapshot> {
        //let container = self.container
        
        let firebaseQuery = FIRDatabase.database().reference().child("photos").queryOrderedByKey()
        
        return firebaseQuery.rx_observe(.childAdded)

        
    }
    
    
}


//
//  UserSettingsViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import PKHUD

extension UserSettingsViewController {
    
    func handleLogout() {
        print("me deberia desloguear")
        HUD.show(.label("Logout..."))
        authManager.output = self
        authManager.logout()
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
        HUD.flash(.success, delay: 1.0)
    }
    
    func handleModifyUser() {
        print("deberia modificar datos de usuario")
        goToModifyUser()
        
    }
    
    func handleLikeNotificationSwitchChanged(sender: UISwitch) {
        print("movieron el switch a: \(sender.isOn)")
    }
    
    func handleFavoritePostSwitchChanged(sender: UISwitch) {
        print("movieron el switch a: \(sender.isOn)")
    }
    
    func handleAdultContentSwitchChanged(sender: UISwitch) {
        print("movieron el switch a: \(sender.isOn)")
    }
    
}

extension UserSettingsViewController: FireBaseManagerLogoutOutput {
    
    func userDidLogout(success: Bool) {
        print("FUNCIONA!!!!")
        if success {
            authManager.loginAnonymous()
        }
    }
    
    func userLoginAnonymous(success: Bool) {
        print("TERMINE EL LOGEO")
    }
}




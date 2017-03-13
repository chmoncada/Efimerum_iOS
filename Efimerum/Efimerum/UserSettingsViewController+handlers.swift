//
//  UserSettingsViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension UserSettingsViewController {
    
    func handleLogout() {
        print("me deberia desloguear")
        
        didFinish()
    }
    
    func handleModifyUser() {
        print("deberia modificar datos de usuario")
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

//
//  UserSettingsViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {
    
    lazy var logoutCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = "Logout"
        return cell
    } ()
    
    lazy var likeNotificationCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = "My photos receive a like"
        return cell
    } ()
    
    lazy var favoritesPostNotificationCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = "Photos in my favorites"
        return cell
    } ()
    
    lazy var adultContentCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = "Adult Content"
        return cell
    } ()
    
    lazy var modifyUserCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = "Modify User"
        cell.accessoryType = .disclosureIndicator
        return cell
    } ()
    
    var didMoveFromParent: () -> Void = {}
    
    override func loadView() {
        super.loadView()
        
        // set the title
        self.title = "Settings"
        
        setupLikeNotificationSwitch()
        setupFavoritesPostNotificationSwitch()
        setupAdultContentSwitch()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent == nil {
            didMoveFromParent()
        }
    }
    
    // Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Return the number of rows for each section in your static table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 3
        case 1: return 2
        default: fatalError("Unknown number of sections")
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.logoutCell
            case 1: return self.modifyUserCell
            case 2: return self.adultContentCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.likeNotificationCell
            case 1: return self.favoritesPostNotificationCell
            default: fatalError("Unknown row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "User Settings"
        case 1: return "Notifications"
        default: fatalError("Unknown section")
        }
    }
    
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle social cell selection to toggle checkmark
        if(indexPath.section == 1) {
            
            // deselect row
            tableView.deselectRow(at: indexPath, animated: false)

        }
        
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                handleLogout()
            case 1:
                handleModifyUser()
            default:
                print("no se hace nada")
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
}

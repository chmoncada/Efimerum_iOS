//
//  UserSettingsViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension UserSettingsViewController {
    
    func setupLikeNotificationSwitch() {
        let likeNotificationSwitch = UISwitch(frame: CGRect(x: view.bounds.maxX - 65, y: self.likeNotificationCell.contentView.bounds.minY + 6, width: 51, height: 31))
        likeNotificationSwitch.setOn(true, animated: false)
        likeNotificationSwitch.onTintColor = UIColor.green
        likeNotificationSwitch.addTarget(self, action: #selector(handleLikeNotificationSwitchChanged), for: UIControlEvents.valueChanged)
        self.likeNotificationCell.addSubview(likeNotificationSwitch)
    }
    
    func setupFavoritesPostNotificationSwitch() {
        let favoritesPostNotificationSwitch = UISwitch(frame: CGRect(x: view.bounds.maxX - 65, y: self.favoritesPostNotificationCell.contentView.bounds.minY + 6, width: 51, height: 31))
        favoritesPostNotificationSwitch.setOn(true, animated: false)
        favoritesPostNotificationSwitch.onTintColor = UIColor.green
        favoritesPostNotificationSwitch.addTarget(self, action: #selector(handleFavoritePostSwitchChanged), for: UIControlEvents.valueChanged)
        self.favoritesPostNotificationCell.addSubview(favoritesPostNotificationSwitch)
    }
    
    func setupAdultContentSwitch() {
        let adultContentSwitch = UISwitch(frame: CGRect(x: view.bounds.maxX - 65, y: self.adultContentCell.contentView.bounds.minY + 6, width: 51, height: 31))
        adultContentSwitch.setOn(true, animated: false)
        adultContentSwitch.onTintColor = UIColor.green
        adultContentSwitch.addTarget(self, action: #selector(handleAdultContentSwitchChanged), for: UIControlEvents.valueChanged)
        self.adultContentCell.addSubview(adultContentSwitch)
    }
}

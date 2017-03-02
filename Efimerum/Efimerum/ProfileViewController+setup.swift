//
//  ProfileViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension ProfileViewController {
    
    func setupPhotoSegmentedControl() {
        //need x, y, width, heigth contraint
        photoSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        photoSegmentedControl.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        photoSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        photoSegmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 40).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupEmailLabel() {
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 40).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    
}

//
//  ModifyUserViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import Kingfisher

extension ModifyUserViewController {
    
    func setupProfileImageView() {
        //need x, y, width, heigth contraint
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setupModifyPhotoButton() {
        modifyPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        modifyPhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        modifyPhotoButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        modifyPhotoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel.topAnchor.constraint(equalTo: modifyPhotoButton.bottomAnchor, constant: 30).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupNameTextFiedl() {
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .none
    }
    
}

extension ModifyUserViewController: ModifyUserViewControllerInput {
    
    func bindViewWithName(_ name: String, email: String, imageURL: URL?) {
        
        if let imageURL = imageURL {
            profileImageView.kf.setImage(with: imageURL)
        } else {
            profileImageView.image = UIImage(named: "default_user_icon")
        }
        
        nameTextField.placeholder = name
        
    }
    
    
}


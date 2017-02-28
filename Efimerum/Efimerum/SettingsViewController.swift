//
//  SettingsViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import Kingfisher

protocol SettingsViewControllerOutput {
    
    func getDataFromUser()
}

protocol SettingsViewControllerInput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}


class SettingsViewController: UIViewController {

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flame")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let closeButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleDismissView), for: .touchUpInside)
        return button
        
    }()
    
    let nameLabel: UILabel = {
        let tf = UILabel()
        tf.textColor = UIColor.white
        //tf.backgroundColor = .red
        tf.textAlignment = .center
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailLabel: UILabel = {
        let tf = UILabel()
        tf.textColor = UIColor.white
        //tf.backgroundColor = .blue
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 12)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var output: SettingsViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        view.addSubview(profileImageView)
        setupProfileImage()
        
        view.addSubview(nameLabel)
        setupNameLabel()
        
        view.addSubview(emailLabel)
        setupEmailLabel()
        
        
        SettingsConfigurator.instance.configure(viewController: self)
        
        output.getDataFromUser()
        
        
    }
    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
    
    func handleDismissView() {
        
        let _ = navigationController?.popViewController(animated: false)
    }
    
}

extension SettingsViewController: SettingsViewControllerInput {
    
    func bindViewWithName(_ name: String, email: String, imageURL: URL?) {
        
        profileImageView.kf.setImage(with: imageURL!)
        nameLabel.text = name
        emailLabel.text = email
    }

    
}


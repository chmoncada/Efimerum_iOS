//
//  ModifyUserViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

protocol ModifyUserViewControllerOutput {
    
    func getDataFromUser()
    func updateUserInfo(withNewName newName: String?, newImage: UIImage?, completion: @escaping (Bool) -> Void)
}

protocol ModifyUserViewControllerInput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

class ModifyUserViewController: UIViewController {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flame")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let modifyPhotoButton: UIButton = {
        
        let button = UIButton(type:UIButtonType.custom)
        button.setTitle("Modify Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    var output: ModifyUserViewControllerOutput!
    
    var infoChanged: Bool? {
        didSet {
            if let infoChanged = infoChanged {
                self.navigationItem.rightBarButtonItem?.isEnabled = infoChanged
            }
        }
    }
    
    var imageChanged = false
    var textChanged = false
    
    var didFinish: () -> Void = {}
    var didMoveFromParent: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModifyUserConfigurator.instance.configure(viewController: self)
        
        self.title = "Modify User"
        
        view.addSubview(profileImageView)
        setupProfileImageView()
        
        view.addSubview(modifyPhotoButton)
        setupModifyPhotoButton()
        
        view.addSubview(nameLabel)
        setupNameLabel()
        
        view.addSubview(nameTextField)
        setupNameTextFiedl()
        
        output.getDataFromUser()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSaveChanges))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
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
}

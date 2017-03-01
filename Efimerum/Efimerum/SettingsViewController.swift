//
//  SettingsViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 27/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import GreedoLayout
import Kingfisher

protocol SettingsViewControllerOutput {
    
    func getDataFromUser()
}

protocol SettingsViewControllerInput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

private let reuseIdentifier =  "PhotoWallCell"

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
    
    lazy var photoSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["My Photos", "My Likes"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        //sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    lazy var model: PhotoWallModelType = {
        let model = PhotoWallFirebaseModel(name: "UserPhotos")
        return model
    }()
    
    lazy var collectionViewSizeCalculator: GreedoCollectionViewLayout = {
        let lazyLayout = GreedoCollectionViewLayout(collectionView: self.collectionView)
        lazyLayout?.dataSource = self
        
        return lazyLayout!
    }()
    
    var collectionView: UICollectionView!
    
    var output: SettingsViewControllerOutput!
    
    var didSelectPhoto: (PhotoWallModelType, Int) -> Void = { _ in }
    
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
        
        view.addSubview(photoSegmentedControl)
        setupPhotoSegmentedControl()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // Set the collection view
        let frame = CGRect(x: 0, y: 266, width: self.view.bounds.width, height: self.view.bounds.height - 266)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = 50
        self.collectionViewSizeCalculator.fixedHeight = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Register the collection view cell
        self.collectionView.register(PhotoWallCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(collectionView)
        //setupCollectionView()
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = self.collectionView.bounds.height / 3
        self.collectionViewSizeCalculator.fixedHeight = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupBindings()
        
        SettingsConfigurator.instance.configure(viewController: self)
        
        output.getDataFromUser()
        
        
    }
    
    func setupPhotoSegmentedControl() {
        //need x, y, width, heigth contraint
        photoSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        photoSegmentedControl.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        photoSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        photoSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
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
    
    
    private func setupBindings() {
        // Reload our collection view when the model changes
        model.didUpdate = { [weak self] in
            
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
            self?.collectionViewSizeCalculator.clearCache()
        }
        
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

// MARK: UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let photo = self.model.photo(at: indexPath.item)
        
        if let photoCell = cell as? PhotoWallCell {
            
            photoCell.backgroundColor = UIColor.clear
            
            let url = photo.thumbnailURL
                photoCell.photoView.kf.indicatorType = .activity
                photoCell.photoView.kf.setImage(with: url)
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.numberOfPhotos
    }
}

// MARK: UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectPhoto(self.model, indexPath.item)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionViewSizeCalculator.sizeForPhoto(at: indexPath)
    }
}

// MARK: GreedoCollectionViewLayoutDataSource

extension SettingsViewController: GreedoCollectionViewLayoutDataSource {
    
    func greedoCollectionViewLayout(_ layout: GreedoCollectionViewLayout!, originalImageSizeAt indexPath: IndexPath!) -> CGSize {
        if (indexPath.item < self.model.numberOfPhotos) {
            let asset = self.model.photo(at: indexPath.item)
            return CGSize(width: asset.thumbnailWidth , height: asset.thumbnailHeight)
        }
        return CGSize(width: 0.1, height: 0.1)
    }
}

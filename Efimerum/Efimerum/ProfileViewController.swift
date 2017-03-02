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

protocol ProfileViewControllerOutput {
    
    func getDataFromUser()
}

protocol ProfileViewControllerInput {
    func bindViewWithName(_ name: String, email: String, imageURL: URL?)
}

private let reuseIdentifier =  "PhotoWallCell"

class ProfileViewController: UIViewController {

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
    
    let settingsButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "settings")
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
        sc.addTarget(self, action: #selector(handleCollectionChange(sender:)), for: .valueChanged)
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
    
    var output: ProfileViewControllerOutput!
    
    var didSelectPhoto: (Photo) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        view.addSubview(settingsButton)
        setupSettingsButton()
        
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
        let frame = CGRect(x: 0, y: 260, width: self.view.bounds.width, height: self.view.bounds.height - 260)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView = UIImageView(image: UIImage(named: "wallpaper"))
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = 50
        self.collectionViewSizeCalculator.fixedHeight = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Register the collection view cell
        self.collectionView.register(PhotoWallCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(collectionView)
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = self.collectionView.bounds.height / 3
        self.collectionViewSizeCalculator.fixedHeight = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupBindings()
        
        ProfileConfigurator.instance.configure(viewController: self)
        
        output.getDataFromUser()
        
        
    }
    
    private func setupBindings() {
        // Reload our collection view when the model changes
        model.didUpdate = { [weak self] in
            
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
            self?.collectionViewSizeCalculator.clearCache()
        }
        
    }
    
}

extension ProfileViewController: ProfileViewControllerInput {
    
    func bindViewWithName(_ name: String, email: String, imageURL: URL?) {
        
        profileImageView.kf.setImage(with: imageURL!)
        nameLabel.text = name
        emailLabel.text = email
    }

    
}

// MARK: UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let photo = self.model.photo(at: indexPath.item)
        
        if let photoCell = cell as? PhotoWallCell {
            photoCell.setupWithPhoto(photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.numberOfPhotos
    }
}

// MARK: UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectPhoto(self.model.photo(at: indexPath.item))
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionViewSizeCalculator.sizeForPhoto(at: indexPath)
    }
}

// MARK: GreedoCollectionViewLayoutDataSource

extension ProfileViewController: GreedoCollectionViewLayoutDataSource {
    
    func greedoCollectionViewLayout(_ layout: GreedoCollectionViewLayout!, originalImageSizeAt indexPath: IndexPath!) -> CGSize {
        if (indexPath.item < self.model.numberOfPhotos) {
            let asset = self.model.photo(at: indexPath.item)
            return CGSize(width: asset.thumbnailWidth , height: asset.thumbnailHeight)
        }
        return CGSize(width: 0.1, height: 0.1)
    }
}

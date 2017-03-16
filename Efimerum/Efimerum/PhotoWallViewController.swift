//
//  PhotoWallViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 05/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import GreedoLayout

private let reuseIdentifier =  "PhotoWallCell"

protocol PhotoWallViewControllerOutput {
    func postPhotoWithImageData(_ imageData: Data, withLocationManager userlocationManager: UserLocationManager?)
}

class PhotoWallViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    // MBFloatScrollButtons
    var orderByButton :MBFloatScrollButton!
    var searchButton :MBFloatScrollButton!
    
    // Called when the user selects a photo in the grid
    var didSelectPhoto: (PhotoWallModelType, Int) -> Void = { _ in }
    var didShowSinglePhoto: (String) -> Void = { _ in }
    var goToProfile: () -> Void = {}
    var needAuthLogin: (String) -> Void = {_ in }
    var selectedTag: String = ""
    var selectedFilter: FilterType = .random
    
    var output: PhotoWallViewControllerOutput!
    
    // Set the customLayout as lazy property
    lazy var collectionViewSizeCalculator: GreedoCollectionViewLayout = {
        let lazyLayout = GreedoCollectionViewLayout(collectionView: self.collectionView)
        lazyLayout?.dataSource = self
        
        return lazyLayout!
    }()
    
    lazy var authInteractor: AuthInteractor = {
        let interactor = AuthInteractor.instance
        return interactor
    }()
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    var model: PhotoWallModelType?
    
    var userLocationManager :UserLocationManager?
    
    init(model: PhotoWallModelType = PhotoWallFirebaseModel()) {
        
        super.init(nibName: nil, bundle: nil)
        
        // the photos to show
        self.model = model
        
        // The custom layout use a Flow Layout in the barebones
        setupLayout()
        
        
        // Set the collection view
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.black
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = self.collectionView.bounds.height / 3
        self.collectionViewSizeCalculator.fixedHeight = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Register the collection view cell
        self.collectionView.register(PhotoWallCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add the collectionView to the view
        self.view.addSubview(collectionView)
        
        // set floatButtons
        setupFloatButtons(scroll: collectionView)
        
        // setup bindings
        setupBindings()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoWallConfigurator.instance.configure(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hides the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
}

// MARK: UICollectionViewDataSource

extension PhotoWallViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let photo = self.model?.photo(at: indexPath.item)
        
        if let photoCell = cell as? PhotoWallCell {
            photoCell.setupWithPhoto(photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.numberOfPhotos
    }
}

// MARK: UICollectionViewDelegate

extension PhotoWallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectPhoto(self.model!, indexPath.item)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PhotoWallViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionViewSizeCalculator.sizeForPhoto(at: indexPath)
    }
}

// MARK: GreedoCollectionViewLayoutDataSource

extension PhotoWallViewController: GreedoCollectionViewLayoutDataSource {
    
    func greedoCollectionViewLayout(_ layout: GreedoCollectionViewLayout!, originalImageSizeAt indexPath: IndexPath!) -> CGSize {
        if (indexPath.item < self.model!.numberOfPhotos) {
            if let asset = self.model?.photo(at: indexPath.item) {
                return CGSize(width: asset.thumbnailWidth , height: asset.thumbnailHeight)
            }
        }
        return CGSize(width: 0.1, height: 0.1)
    }
}


extension PhotoWallViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePicture() {
        
        userLocationManager = UserLocationManager()
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)  {
            
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true) { }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let fixedImage = image.fixOrientation()
        let imageData = UIImageJPEGRepresentation(fixedImage, 0.5)!
        //        let data = UIImagePNGRepresentation(image)
        
        picker.dismiss(animated: true) {
            
        }
        
        output.postPhotoWithImageData(imageData, withLocationManager: userLocationManager)
    }

}







//
//  PhotoWallViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 05/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import GreedoLayout
import Photos
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier =  "PhotoWallCell"


class PhotoWallViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    // Called when the user selects a photo in the grid
    var didSelectPhoto: (PhotoWallModelType, Int) -> Void = { _ in }
    var goToProfile: () -> Void = {}
    
    // Set the customLayout as lazy property
    lazy var collectionViewSizeCalculator: GreedoCollectionViewLayout = {
        let lazyLayout = GreedoCollectionViewLayout(collectionView: self.collectionView)
        lazyLayout?.dataSource = self
        
        return lazyLayout!
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


extension PhotoWallViewController :MBFloatScrollButtonDelegate {
    
    func didTapOnCamera(button: MBFloatScrollButton) {
        takePicture()
    }
    
    func didTapOnProfile(button: MBFloatScrollButton) {
        goToProfile()
    }
    
    func didTap(filter: FilterType) {
        print(filter.getText())
    }
    
    func didTypeSearchChanged(text: String) {
        print("text being tap to search: \(text)")
    }
    
    func didTapOnSearchDone(text: String) {
         print("text for the search by tag: \(text)")
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
        let imageData = UIImageJPEGRepresentation(fixedImage, 0.5)
        //        let data = UIImagePNGRepresentation(image)
        
        picker.dismiss(animated: true) {
            
        }
        
        let currentUser = FIRAuth.auth()?.currentUser
        currentUser?.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
                // Handle error
                print(error)
                return;
            }
            
            let location = self.userLocationManager?.currentLocation
            
            if let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude {
                
                print("latitude: \(latitude) - longitude: \(longitude)")
            }
            self.userLocationManager?.locationManager.stopUpdatingLocation()
            

            ApiClient.upload(data: imageData!, endpoint: .photos(token: idToken!, latitude: 41.375395, longitude: 2.170624), completionHandler: { (result) in
                
                print(result)
                
            })
        }
    }
    
    
    
}









































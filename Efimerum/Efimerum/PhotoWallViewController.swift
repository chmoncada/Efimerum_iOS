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

private let reuseIdentifier =  "PhotoWalletCell"

class PhotoWallViewController: UIViewController {

    
    var collectionView: UICollectionView!
    
    // Called when the user selects a photo in the grid
    // TODO: We need to pass some data to the other view (hint: the arrays of photos and the index of the selected)
    var didSelectPhoto: (Int) -> Void = { _ in }
    
    // Set the customLayout as lazy property
    lazy var collectionViewSizeCalculator: GreedoCollectionViewLayout = {
        let lazyLayout = GreedoCollectionViewLayout(collectionView: self.collectionView)
        lazyLayout?.dataSource = self
        
        return lazyLayout!
    }()
    
    // TODO: wrap the model to his own class
    var assetFetchResults: PHFetchResult<PHAsset>?
    
    init(assetFetchResults: PHFetchResult<PHAsset> = allElementsFromLibrary()) {
        
        super.init(nibName: nil, bundle: nil)
        
        // the photos to show
        self.assetFetchResults = assetFetchResults
        
        // The custom layout use a Flow Layout in the barebones
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // Set the collection view
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        // Settings of Custom layout
        self.collectionViewSizeCalculator.rowMaximumHeight = self.collectionView.bounds.height / 3
        self.collectionViewSizeCalculator.fixedHeight = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Register the collection view cell
        // TODO: make it entirely in code
        let nib = UINib(nibName: "PhotoWallCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add the collectionView to the view
        self.view.addSubview(collectionView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hides the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

}

// MARK: UICollectionViewDataSource

extension PhotoWallViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = self.assetFetchResults?[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let photoCell = cell as? PhotoWallCollectionViewCell {
            
            photoCell.backgroundColor = UIColor.clear
            
            // put the photo from carrousel in the cell
            let options = PHImageRequestOptions()
            options.resizeMode = .fast
            options.deliveryMode = .opportunistic
            options.version = .current
            options.isSynchronous = false
            
            let scale = min(2.0, UIScreen.main.scale)
            let requestImageSize = CGSize(width: cell.bounds.width * scale, height: cell.bounds.height * scale)
            PHCachingImageManager.default().requestImage(for: asset!,
                                                         targetSize: requestImageSize,
                                                         contentMode: PHImageContentMode.aspectFit,
                                                         options: options,
                                                         resultHandler: { (result, info) in
                                                            photoCell.photoView.image = result
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults!.count
    }
}

// MARK: UICollectionViewDelegate

extension PhotoWallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("apretaron el index: \(indexPath.item)")
        didSelectPhoto(indexPath.item)
        //let photoDetailDragViewController = PhotoDetailDragViewController()
        
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
        if (indexPath.item < self.assetFetchResults!.count) {
            let asset = (self.assetFetchResults?[indexPath.item])!
            return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        }
        
        return CGSize(width: 0.1, height: 0.1)
    }
}



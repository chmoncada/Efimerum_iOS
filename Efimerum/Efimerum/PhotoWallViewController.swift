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
    
    //var assetFetchResults: PHFetchResult<PHAsset>?
    var model: PhotoWallModelType?
    
    
    init(model: PhotoWallModelType) {
        
        super.init(nibName: nil, bundle: nil)
        
        // the photos to show
        self.model = model
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let asset = self.model?.photo(at: indexPath.item)
        
        if let photoCell = cell as? PhotoWallCollectionViewCell {
            
            photoCell.backgroundColor = UIColor.clear
            
            photoCell.photoView.image = asset
            
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
        
        didSelectPhoto(indexPath.item)
        
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
            let asset = (self.model?.photo(at: indexPath.item))!
            return CGSize(width: asset.size.width, height: asset.size.height)
        }
        
        return CGSize(width: 0.1, height: 0.1)
    }
}



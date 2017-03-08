//
//  PhotoWallViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

extension PhotoWallViewController {
    
    func handleTakePhoto() {
        
        if self.authInteractor.isNotAuthenticated() {
            print("me apretaron a ver si funciona esto en la vista photowall")
            needAuthLogin()
        } else {
            takePicture()
        }
        
    }
    
    func handleFilter(_ filter: String) {
        
        switch filter {
        case "Most Liked":
            print("ordenar por likes")
            //model = PhotoWallFirebaseModel(name: "LikesPhotos")
            model = PhotoWallFirebaseModel(sortedKey: "numOfLikes")
        case "About to die":
            print("ordenar por vida")
        default:
            print(filter)
        }
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.collectionViewSizeCalculator.clearCache()
        
        setupBindings()
        
    }
    
}

extension PhotoWallViewController :MBFloatScrollButtonDelegate {
    
    func didTapOnCamera(button: MBFloatScrollButton) {
        handleTakePhoto()
    }
    
    func didTapOnProfile(button: MBFloatScrollButton) {
        goToProfile()
    }
    
    func didTap(filter: FilterType) {
        handleFilter(filter.getText())
    }
    
    func didTypeSearchChanged(text: String) {
        print("text being tap to search: \(text)")
    }
    
    func didTapOnSearchDone(text: String) {
        print("text for the search by tag: \(text)")
    }
}

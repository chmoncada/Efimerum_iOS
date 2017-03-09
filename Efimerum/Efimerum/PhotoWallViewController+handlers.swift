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
            needAuthLogin()
        } else {
            takePicture()
        }
        
    }
    
    func handleModelFilter(_ filter: String) {
        
        if model?.labelQuery == "" {
            print("no tengo query")
        }
        
        switch filter {
        case "Most Liked":
            print("ordenar por likes")
            model = PhotoWallFirebaseModel(sortedKey: "numOfLikes")
        case "About to die":
            print("ordenar por vida")
            model = PhotoWallFirebaseModel()
        default:
            print(filter)
        }
        
        reloadGrid()
        
    }
    
    func handleTagSelection(_ text: String) {
        
        model = PhotoWallFirebaseModel(labelQuery: text)
        
        reloadGrid()
        
    }
    
    func reloadGrid() {
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
        handleModelFilter(filter.getText())
    }
    
    func didTypeSearchChanged(text: String) {
        print("text being tap to search: \(text)")
    }
    
    func didTapOnSearchDone(text: String) {
        selectedTag = text
        handleTagSelection(selectedTag)
    }
}

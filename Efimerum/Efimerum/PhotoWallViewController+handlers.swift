//
//  PhotoWallViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 07/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import PKHUD

extension PhotoWallViewController {
    
    func handleTakePhoto() {
        
        if self.authInteractor.isNotAuthenticated() {
            needAuthLogin("takePhoto")
        } else {
            takePicture()
        }
        
    }
    
    func handleModelFilter(_ filter: FilterType) {
        
        model = PhotoWallFirebaseModel(labelQuery: selectedTag, sortedBy: filter)
        reloadGrid()
        
    }
    
    func handleTagSelection(_ text: String) {
        
        model = PhotoWallFirebaseModel(labelQuery: text, sortedBy: selectedFilter)
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
        if self.orderByButton.isShowingMenu {
            self.orderByButton.dismissMenu()
        }
        handleTakePhoto()
    }
    
    func didTapOnProfile(button: MBFloatScrollButton) {
        if self.orderByButton.isShowingMenu {
            self.orderByButton.dismissMenu()
        }
        if self.authInteractor.isNotAuthenticated() {
            needAuthLogin("profile")
        } else {
            goToProfile()
        }
        
    }
    
    func didTap(filter: FilterType) {
        selectedFilter = filter
        handleModelFilter(filter)
    }
    
    func didBeginSearch(button: MBFloatScrollButton) {
        
        if self.orderByButton.isShowingMenu {
            self.orderByButton.dismissMenu()
        }
    }
    
    func didTypeSearchChanged(text: String) {
        print("text being tap to search: \(text)")
    }
    
    func didTapOnSearchDone(text: String) {
        selectedTag = text
        handleTagSelection(selectedTag)
    }
}


extension PhotoWallViewController :PhotoInteractorOutput {
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func dismissLoadingSuccess() {
        HUD.flash(.success, delay: 1.0)
    }
    
    func dismissLoadingFailed() {
        HUD.flash(.error, delay: 1.0)
    }

}



















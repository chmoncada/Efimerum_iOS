//
//  PhotoDetailDragViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 26/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation

extension PhotoDetailDragViewController {
    
    func handleDismissView() {
        
        if indexesToDelete.count > 0 {
            output.deletePhotosOfIndexes(indexesToDelete)
        }
        
        let _ = navigationController?.popViewController(animated: false)
    }
    
    func handleLogout() {
        output.logout()
    }
    
    func handleLikePhotoWithIdentifier(_ identifier: String) {
        
        if self.authInteractor.isNotAuthenticated() {
            needAuthLogin(identifier)
        } else {
            output.likeToPhotoWithIdentifier(identifier)
        }
        
    }
    
    func handleInfo() {
        
        let index = kolodaView.currentCardIndex
        let photo = model?.photo(at: startIndex + index)
        let identifier = photo!.identifier
        print(identifier)
        didAskPhotoInfo(identifier)
    }
    
    func handleSkipButton() {
        kolodaView.swipe(.left)
    }
    
    func handleLikeButton() {
        kolodaView.swipe(.right)
    }
    
    func handleTouch() {
        
        closeButton.isHidden = !closeButton.isHidden
        logoutButton.isHidden = !logoutButton.isHidden
    }
    
    
}

//
//  PhotoDetailDragViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 26/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import Social

extension PhotoDetailDragViewController {
    
    func handleDismissView() {
        
        if indexesToDelete.count > 0 {
            output.deletePhotosOfIndexes(indexesToDelete)
        }
        
        let _ = navigationController?.popViewController(animated: false)
    }
    
    func handleLikePhotoWithIdentifier(_ identifier: String, userLocationManager: UserLocationManager) {
        
        let location = userLocationManager.currentLocation
        if self.authInteractor.isNotAuthenticated() {
            needAuthLogin(identifier, location)
        } else {
            output.likeToPhotoWithIdentifier(identifier, location: location)
        }
        
    }
    
    func handleReport() {
        print("reporta esta foto al backend")
    }
    
    func handleShare() {
        print("Comparte esta foto")
        
        let alert = UIAlertController(title: "Sharing photo...", message: nil, preferredStyle: .alert)
        let twitterAction = UIAlertAction(title: "Share in Twitter", style: .default) { _ in
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("Hola")
            
            self.present(vc!, animated: true, completion: nil)
        }
        alert.addAction(twitterAction)
        
        let facebookAction = UIAlertAction(title: "Share in Facebok", style: .default) { _ in
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc?.setInitialText("Hola")
            
            self.present(vc!, animated: true, completion: nil)
        }
        alert.addAction(facebookAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleInfo() {
        
        let index = kolodaView.currentCardIndex
        
        if let photo = model?.photo(at: startIndex + index) {
            didAskPhotoInfo(photo)
        }

    }
    
    func handleSkipButton() {
        kolodaView.swipe(.left)
    }
    
    func handleLikeButton() {
        kolodaView.swipe(.right)
    }
    
    func handleTouch() {
        
        closeButton.isHidden = !closeButton.isHidden
        reportButton.isHidden = !reportButton.isHidden
    }
    
    
}

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
        
        let alertController = UIAlertController(title: "REPORT THIS PHOTO", message: "Select a reason", preferredStyle: .actionSheet)
        
        let reportCodes = ["reason1", "reason2", "reason3", "reason4"]
        
        for code in reportCodes {
            alertController.addAction(UIAlertAction(title: code, style: .default, handler: { (action) in
                self.reportPhotoWith(reasonCode: code)
            }))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    func reportPhotoWith(reasonCode code: String) {
        let index = kolodaView.currentCardIndex
        
        if let photo = model?.photo(at: startIndex + index) {
            output.reporPhotoWith(identifier: photo.identifier, code: code)
            reportButton.isEnabled = false
        }
    }
    
    
    func handleShare() {
        
        var linkText: String = ""
        let index = kolodaView.currentCardIndex
        
        if let photo = model?.photo(at: startIndex + index) {
            linkText = photo.dynamicLink
            if linkText != "" {
                let shareText = "Look this photo at Efimerum!!.  Click this link: " + linkText
                
                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                
                activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                
                //Chequear si estamos en un iPad, si quieres te paso la extension para esto
                /*
                 if UIDevice().screenType == .iPad {
                 // esto es para que no pete en iPad, hay que decirle que parte de una vista, en tu caso en la vista del boton de compartir
                 //activityViewController.popoverPresentationController?.sourceView = cell.shareButton
                 }
                 */
                
                self.present(activityViewController, animated: true, completion: nil)
            }
       
        }
   
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
        
//        closeButton.isHidden = !closeButton.isHidden
//        reportButton.isHidden = !reportButton.isHidden
    }
    
    
}

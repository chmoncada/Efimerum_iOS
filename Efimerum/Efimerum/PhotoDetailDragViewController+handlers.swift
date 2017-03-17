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
        let index = kolodaView.currentCardIndex
        
        if let photo = model?.photo(at: startIndex + index) {
            output.reporPhotoWith(identifier: photo.identifier, code: "adult")
        }

    }
    
    func handleShare() {
//        print("Comparte esta foto")
//        
//        let alert = UIAlertController(title: "Sharing photo...", message: nil, preferredStyle: .alert)
//        let twitterAction = UIAlertAction(title: "Share in Twitter", style: .default) { _ in
//            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            vc?.setInitialText("Hola")
//            
//            self.present(vc!, animated: true, completion: nil)
//        }
//        alert.addAction(twitterAction)
//        
//        let facebookAction = UIAlertAction(title: "Share in Facebok", style: .default) { _ in
//            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            vc?.setInitialText("Hola")
//            
//            self.present(vc!, animated: true, completion: nil)
//        }
//        alert.addAction(facebookAction)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
        
        let shareText = "texto y deeplink a compartir"
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        //activityViewController.setValue("texto y deeplink a compartir")
        //New Excluded Activities Code
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        //Chequear si estamos en un iPad, si quieres te paso la extension para esto
        if UIDevice().screenType == .iPad {
            // esto es para que no pete en iPad, hay que decirle que parte de una vista, en tu caso en la vista del boton de compartir
            //activityViewController.popoverPresentationController?.sourceView = cell.shareButton
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
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

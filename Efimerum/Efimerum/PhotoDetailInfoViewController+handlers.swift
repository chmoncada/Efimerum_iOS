//
//  PhotoDetailInfoViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 11/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import PKHUD

extension PhotoDetailInfoViewController {
    
    func handleDismissView() {
        
        didFinish()
    }
    
    func handleTap() {
        closeButton.isHidden = !closeButton.isHidden
    }
    
    func getAuthorName(userID: String) {
        
        let manager = FirebaseDatabaseManager.instance
        
        manager.getUserDataForUserWithUID(userID) { (name, email, url) in
            
            if let author = name {
                self.setupInfoLabelsWith(authorName: author)
            } else {
                self.setupInfoLabelsWith(authorName: "Efimerum")
            }
        }
    }
    
}

extension PhotoDetailInfoViewController :UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        HUD.hide()
    }
}

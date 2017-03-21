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

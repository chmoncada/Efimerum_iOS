//
//  PhotoDetailInfoViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 11/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import Kingfisher

extension PhotoDetailInfoViewController {
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.isHidden = false
    }
    
    func setupScreenView() {
        screenView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        screenView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        screenView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        screenView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    func setupWebview() {
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    
}


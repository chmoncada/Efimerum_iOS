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
    
    func setupFooterView() {
        footerView.bottomAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        footerView.leftAnchor.constraint(equalTo: webView.leftAnchor).isActive = true
        footerView.widthAnchor.constraint(equalTo: webView.widthAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let numOfLikes = UILabel(frame: CGRect.zero)
        numOfLikes.frame = CGRect(x: footerView.bounds.origin.x + 8,
                                   y: footerView.bounds.origin.y + 8,
                                   width: 100,
                                   height: 20)
        
        numOfLikes.text = "Number of likes: \(Int(self.photo!.numOfLikes))"
        numOfLikes.textColor = .white
        numOfLikes.adjustsFontSizeToFitWidth = true
        numOfLikes.textAlignment = .left
        footerView.addSubview(numOfLikes)

    }
    
    
}


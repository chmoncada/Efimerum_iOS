//
//  PhotoDetailDragViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 26/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import CoreGraphics


private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0

extension PhotoDetailDragViewController {
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.isHidden = true
    }
    
    func setupInfoButton() {
        infoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupSkipButton() {
        
        skipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupLikeButton() {
        likeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // TEMPORAL FUNC
    
    func setupLogoutButton() {
        logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        logoutButton.isHidden = true
    }
    
    func setupKolodaView() {
        kolodaView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

    }
}

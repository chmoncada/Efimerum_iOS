//
//  SinglePhotoDetailViewController+setup.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import Kingfisher

extension SinglePhotoDetailViewController {
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.isHidden = true
    }
    
    func setupScreenView() {
        screenView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        screenView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        screenView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        screenView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    
    func setupInfoButton() {
        infoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 10).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: self.view.bounds.width / 10).isActive = true
    }
    
    func setupContentView() {
        
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let aspectRatio = CGFloat((photo?.imageHeight)! / (photo?.imageWidth)!)
            let cardAspectRatio = self.view.bounds.width / self.view.bounds.height
            
            if contentView.bounds.width > contentView.bounds.height || contentView.bounds.width == contentView.bounds.height {
                
                let width = NSLayoutConstraint(
                    item: contentView,
                    attribute: NSLayoutAttribute.width,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.width,
                    multiplier: 0.95,
                    constant: 0)
                let height = NSLayoutConstraint(
                    item: contentView,
                    attribute: NSLayoutAttribute.height,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.height,
                    multiplier: aspectRatio * 0.95 * cardAspectRatio,
                    constant: 0)
                let centerX = NSLayoutConstraint (
                    item: contentView,
                    attribute: NSLayoutAttribute.centerX,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.centerX,
                    multiplier: 1.0,
                    constant: 0)
                let centerY = NSLayoutConstraint (
                    item: contentView,
                    attribute: NSLayoutAttribute.centerY,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.centerY,
                    multiplier: 1.0,
                    constant: 0)
                self.view.addConstraints([width, height,centerX, centerY])
            } else {
                
                let height = NSLayoutConstraint(
                    item: contentView,
                    attribute: NSLayoutAttribute.height,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.height,
                    multiplier: 0.95,
                    constant: 0)
                let width = NSLayoutConstraint(
                    item: contentView,
                    attribute: NSLayoutAttribute.width,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.width,
                    multiplier: 0.95 / ( cardAspectRatio * aspectRatio) ,
                    constant: 0)
                let centerX = NSLayoutConstraint (
                    item: contentView,
                    attribute: NSLayoutAttribute.centerX,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.centerX,
                    multiplier: 1.0,
                    constant: 0)
                let centerY = NSLayoutConstraint (
                    item: contentView,
                    attribute: NSLayoutAttribute.centerY,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.centerY,
                    multiplier: 1.0,
                    constant: 0)
                self.view.addConstraints([width, height,centerX, centerY])
            }
        
        if let url = photo?.imageURL {
            self.contentView.kf.indicatorType = .activity
            self.contentView.kf.setImage(with: url)
        }
        
    }
    
}

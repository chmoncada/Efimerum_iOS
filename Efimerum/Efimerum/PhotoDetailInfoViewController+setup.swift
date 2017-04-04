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
        
        getAuthorName(userID: self.photo!.authorID)
        
//        setupInfoLabelsWith(authorName: "Unknown")
    }
    
    func setupInfoLabelsWith(authorName: String) {
        let author = UILabel(frame: CGRect.zero)
        author.frame = CGRect(x: footerView.bounds.origin.x + 8,
                              y: footerView.bounds.origin.y + 6,
                              width: UIScreen.main.bounds.size.width - 16,
                              height: 15)
        
        author.text = "Author: \(authorName)"
        author.textColor = .white
        author.adjustsFontSizeToFitWidth = true
        author.textAlignment = .left
        footerView.addSubview(author)
        
        let numOfLikes = UILabel(frame: CGRect.zero)
        numOfLikes.frame = CGRect(x: footerView.bounds.origin.x + 8,
                                  y: author.frame.origin.y + author.bounds.size.height + 6,
                                  width: UIScreen.main.bounds.size.width - 16,
                                  height: 15)
        
        numOfLikes.text = "Number of likes: \(Int(self.photo!.numOfLikes))"
        numOfLikes.textColor = .white
        numOfLikes.adjustsFontSizeToFitWidth = true
        numOfLikes.textAlignment = .left
        footerView.addSubview(numOfLikes)
        
        let willDie = UILabel(frame: CGRect.zero)
        willDie.frame = CGRect(x: footerView.bounds.origin.x + 8,
                               y: numOfLikes.frame.origin.y + numOfLikes.bounds.size.height + 6,
                               width: UIScreen.main.bounds.size.width - 16,
                               height: 15)
        
        
        let dieDate = UtilTime.getDate(time: self.photo!.expirationDate)
        willDie.text = "Gonna die: \(dieDate)"
        willDie.textColor = .white
        willDie.adjustsFontSizeToFitWidth = true
        willDie.textAlignment = .left
        footerView.addSubview(willDie)
        
        
        let tags = UILabel(frame: CGRect.zero)
        tags.frame = CGRect(x: footerView.bounds.origin.x + 8,
                            y: willDie.frame.origin.y + willDie.bounds.size.height + 6,
                            width: UIScreen.main.bounds.size.width - 16,
                            height: 30)
        
        let tagsArray = UtilTags.getTagsString(tags: self.photo!.tags)
        tags.text = "Tags: \(tagsArray)"
        tags.textColor = .white
        tags.numberOfLines = 2
        tags.adjustsFontSizeToFitWidth = true
        tags.textAlignment = .left
        footerView.addSubview(tags)
    }
    
    
}


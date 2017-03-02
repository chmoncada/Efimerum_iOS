//
//  PhotoWallCell.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 05/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoWallCell: UICollectionViewCell {
 
    
    let photoView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let likesView: UIImageView = {
        
        let view = UIImageView(image: UIImage(named: "heart"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let opaqueView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let likesTextView: UITextView = {
        let tv = UITextView()
        tv.text = "999.99k"
        tv.font = UIFont.systemFont(ofSize: 8)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    let timeIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "firehigh")
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithPhoto(_ photo: Photo?) {
        
        self.backgroundColor = UIColor.clear
        
        if let url = photo?.thumbnailURL {
            self.photoView.kf.indicatorType = .activity
            self.photoView.kf.setImage(with: url)
        }
        
    }
    
    private func setupViews() {
        addSubview(photoView)
        setupPhotoView()
        
        addSubview(opaqueView)
        setupOpaqueView()
        
        
        addSubview(likesView)
        setupLikesView()
        
        addSubview(likesTextView)
        setupLikesTextView()
        
        addSubview(timeIconView)
        setupTimeIconView()
        
        
    }
    
    private func setupPhotoView() {
        //need x, y, width, heigth contraint
        photoView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    private func setupLikesView() {
        //need x, y, width, heigth contraint
        likesView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        likesView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        likesView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        likesView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupOpaqueView() {
        opaqueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        opaqueView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        opaqueView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        opaqueView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    private func setupLikesTextView() {
        likesTextView.leftAnchor.constraint(equalTo: likesView.rightAnchor).isActive = true
        likesTextView.bottomAnchor.constraint(equalTo: likesView.bottomAnchor).isActive = true
        likesTextView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        likesTextView.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
 
    private func setupTimeIconView() {
        timeIconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        timeIconView.bottomAnchor.constraint(equalTo: likesView.bottomAnchor).isActive = true
        timeIconView.heightAnchor.constraint(equalTo: likesView.heightAnchor).isActive = true
        timeIconView.widthAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
}

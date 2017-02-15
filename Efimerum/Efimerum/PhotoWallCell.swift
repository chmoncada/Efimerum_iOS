//
//  PhotoWallCell.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 05/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit

class PhotoWallCell: UICollectionViewCell {
 
    
    let photoView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(photoView)
        setupPhotoView()
        
    }
    
    func setupPhotoView() {
        //need x, y, width, heigth contraint
        photoView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
}

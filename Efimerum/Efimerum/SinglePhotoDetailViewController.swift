//
//  SinglePhotoDetailViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 01/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class SinglePhotoDetailViewController: UIViewController {
   
    let closeButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismissView), for: .touchUpInside)
        return button
        
    }()
    
    let contentView: UIImageView = {
        let cv = UIImageView()
        return cv
    }()
    
    let screenView: UIView = {
        let sv = UIView(frame: CGRect.zero)
        sv.backgroundColor = .black
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var photo: Photo?
    
    init(photo: Photo) {
       super.init(nibName: nil, bundle: nil)
        self.photo = photo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(screenView)
        setupScreenView()
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        view.addSubview(contentView)
        setupContentView()
        
        
        // create an instance of UITapGestureRecognizer and tell it to run
        // an action we'll call "handleTap:"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        // allow for user interaction
        view.isUserInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        view.addGestureRecognizer(tap)
        
    }
    
}

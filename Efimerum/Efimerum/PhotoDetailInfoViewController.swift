//
//  PhotoDetailInfoViewController.swift
//  Efimerum
//
//  Created by Charles Moncada on 11/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class PhotoDetailInfoViewController: UIViewController {
    
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
        sv.backgroundColor = .red
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let webView: UIWebView = {
        let web = UIWebView(frame: CGRect.zero)
        web.backgroundColor = .black
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    let footerView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var photo: Photo?
    
    var didFinish: () -> Void = {}
    
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
        
        view.addSubview(webView)
        setupWebview()
        webView.delegate = self
        if let photo = photo {
            let urlRequest = URLRequest(url: URL(string: "http://efimerum-48618.appspot.com/api/v1/likesMap?photoUUID=\(photo.identifier)")!)
            webView.loadRequest(urlRequest)
        }
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        webView.addSubview(footerView)
        setupFooterView()
        
        // create an instance of UITapGestureRecognizer and tell it to run
        // an action we'll call "handleTap:"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        // allow for user interaction
        view.isUserInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        view.addGestureRecognizer(tap)
        
    }
    
}

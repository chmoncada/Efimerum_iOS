//
//  BubbleView.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 27/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    
    weak var deletegate :BubbleViewDelegate?

    var titleLabel :UILabel!
    var dismissView :UIImageView!
    
    let title :String
    
    init(text: String) {
        self.title = text
        
        let frame = CGRect.zero
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        
        titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.backgroundColor = .white
        titleLabel.sizeToFit()
        
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: titleLabel.bounds.size.width + 60,
                            height: 30)
        
        titleLabel.frame = CGRect(x: self.bounds.origin.x + 10,
                                  y: self.bounds.origin.y,
                                  width: titleLabel.bounds.size.width,
                                  height: 30)
        self.addSubview(titleLabel)
        
        
        
        dismissView = UIImageView(frame: CGRect(x: self.bounds.size.width - 30,
                                                y: self.bounds.origin.y,
                                            width: 30,
                                           height: 30))
        dismissView.backgroundColor = .green
        dismissView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(BubbleView.dismiss))
        dismissView.addGestureRecognizer(tap)
        self.addSubview(dismissView)
        
        
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.5
        self.backgroundColor = .white

    }
    
    func dismiss() {
        
        deletegate?.didTapDismissView(view: self)
    }

}


protocol BubbleViewDelegate :class {

    func didTapDismissView(view: BubbleView)
}









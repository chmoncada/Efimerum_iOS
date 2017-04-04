//
//  FilterItemView.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 12/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class FilterItemView: UIView {
    
    var delegate : FilterItemViewDelegate?

    var imageView : UIImageView!
    var titleLabel : UILabel!
    
    let filterType : FilterType
    
    init(filterType: FilterType) {
        self.filterType = filterType
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: 200,
                           height: 40)
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews()  {
        
        self.imageView = UIImageView(frame: CGRect(x: self.bounds.origin.x,
                                                   y: self.bounds.origin.y,
                                                   width: 40,
                                                   height: 40))
        self.imageView.image = filterType.getImage()
        self.imageView.layer.cornerRadius = self.imageView.bounds.size.height / 2
        self.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(FilterItemView.handleTapAction))
        self.imageView.addGestureRecognizer(tap)
        self.addSubview(self.imageView)
        
        self.titleLabel = UILabel(frame: CGRect(x: self.imageView.bounds.width + 8,
                                                y: self.bounds.origin.y,
                                                width: self.bounds.width - self.imageView.bounds.width,
                                                height: 40))
        self.titleLabel.text = filterType.getText()
        self.titleLabel.textColor = .white
        self.addSubview(self.titleLabel)
        
    }
    
    func handleTapAction()  {
        delegate?.didTap(filter: self)
    }
    
}


protocol FilterItemViewDelegate : class {
    
    func didTap(filter: FilterItemView)
}

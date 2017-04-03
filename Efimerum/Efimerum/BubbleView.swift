//
//  BubbleView.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 27/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    
    weak var delegate :BubbleViewDelegate?
    
    var tagsInteractor = TagsInteractor()

    var titleLabel :UILabel!
    var dismissView :UIImageView!
    
    var favoriteView :UIImageView?
    
    let title :String
    let hasFavoriteAction : Bool
    
    init(text: String, favorite: Bool = false) {
        self.title = text
        self.hasFavoriteAction = favorite
        
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
        
        var labelWidth = titleLabel.bounds.size.width
        
        if labelWidth > 100 {
            labelWidth = 100.0
            titleLabel.frame = CGRect(x: titleLabel.frame.origin.x,
                                      y: titleLabel.frame.origin.y,
                                      width: labelWidth,
                                      height: 30)
        }
        
        titleLabel.adjustsFontSizeToFitWidth = true

        if hasFavoriteAction {
            
            self.frame = CGRect(x: 0,
                                y: 0,
                                width: labelWidth + 70,
                                height: 30)
            
            favoriteView = UIImageView(frame: CGRect(x: self.bounds.origin.x + 2,
                                                     y: self.bounds.origin.y + 5,
                                                     width: 20,
                                                     height: 20))
            
            favoriteView?.contentMode = .center
            updateFavoriteView(tagsInteractor.isFavorite(tag: title))
            favoriteView?.isUserInteractionEnabled = true
            let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(BubbleView.favotiteAction))
            favoriteView?.addGestureRecognizer(tapFavorite)
            self.addSubview(favoriteView!)
            
            titleLabel.frame = CGRect(x: self.bounds.origin.x + favoriteView!.bounds.width + 4,
                                      y: self.bounds.origin.y,
                                      width: labelWidth,
                                      height: 30)
            
        } else {
            
            self.frame = CGRect(x: 0,
                                y: 0,
                                width: labelWidth + 60,
                                height: 30)
        
            titleLabel.frame = CGRect(x: self.bounds.origin.x + 10,
                                  y: self.bounds.origin.y,
                                  width: labelWidth,
                                  height: 30)
        }
        
        self.addSubview(titleLabel)
        
        
        
        dismissView = UIImageView(frame: CGRect(x: self.bounds.size.width - 30,
                                                y: self.bounds.origin.y + 5,
                                            width: 20,
                                           height: 20))
        dismissView.contentMode = .center
        dismissView.image = UIImage(named: "btn_dismiss_bubble")
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
    
    func updateFavoriteView(_ isFavorite: Bool) {
        if isFavorite {
            favoriteView?.image = UIImage(named: "favorite_on")
        } else {
            favoriteView?.image = UIImage(named: "favorite_off")
        }
    }
    
    func dismiss() {
        delegate?.didTapDismissView(view: self)
    }
    
    func favotiteAction() {
        delegate?.didTapFavorite(view: self)
    }

}


protocol BubbleViewDelegate :class {

    func didTapDismissView(view: BubbleView)
    
    func didTapFavorite(view: BubbleView)
}









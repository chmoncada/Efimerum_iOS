//
//  MBFloatScrollButton.swift
//  Efimerum
//
//  Created by Michel on 06/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class MBFloatScrollButton: UIImageView, UIScrollViewDelegate {

    var hideWhileScrolling = true
    let isFloatActionMenu : Bool
    let scrollView :UIScrollView
    var maskBackgroundView :UIControl?
    var delegate :MBFloatScrollButtonDelegate?
    
    var isShowingMenu = false
    
    private var filterItem1 : FilterItemView!
    private var filterItem2 : FilterItemView!
    private var filterItem3 : FilterItemView!
    private var filterItem4 : FilterItemView!
    
    
    var previousOffset :CGFloat = 0.0
    
    init(frame: CGRect, with image: UIImage, on scrollView: UIScrollView, hasFloatAction floatAction: Bool) {
        self.scrollView = scrollView
        self.isFloatActionMenu = floatAction
        previousOffset = self.scrollView.contentOffset.y
        
        super.init(frame: frame)
        self.image = image
        
        setupButton()
        
        if floatAction {
            setMenuButton()
        }

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setMenuButton(){
    
        
        
    }
    
    func setupButton() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFit
        self.image = self.image
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: -10.0, height: -10.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MBFloatScrollButton.tapButtonAction))
        self.addGestureRecognizer(tap)
     
        if hideWhileScrolling {
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    
    }

    
    func tapButtonAction()  {
        
        if isFloatActionMenu {
            if isShowingMenu {
                dismissMenu()
            } else {
                showMenu()
            }
        } else {
            delegate?.didTap(button: self)
        }
    }
    
    //MARK: - Scroll
    
    func setHideWhile(scrolling: Bool) {
        self.hideWhileScrolling = scrolling
        if hideWhileScrolling {
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    func showButtonDuringScroll(shouldShow: Bool) {
        if self.hideWhileScrolling {
            
            if !shouldShow {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: self.frame.origin.y)
                })
            } else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let theKeypath = keyPath else {
            return
        }
        
        if theKeypath == "contentOffset" {
            
            let diff = previousOffset - scrollView.contentOffset.y
            
            if abs(diff) > 15 {
                if scrollView.contentOffset.y > 0 {
                    
                    showButtonDuringScroll(shouldShow: (previousOffset > scrollView.contentOffset.y))
                    previousOffset = scrollView.contentOffset.y
                } else {
                    showButtonDuringScroll(shouldShow: true)
                }
            }
            
        }
    }
    
    
    //MARK: - MenuTable
    
    func showMenu() {
        isShowingMenu = true
        
        self.scrollView.isUserInteractionEnabled = false
        
        self.maskBackgroundView = UIControl(frame: self.scrollView.bounds)
        self.maskBackgroundView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.maskBackgroundView?.isUserInteractionEnabled = true
        self.maskBackgroundView?.addTarget(self, action: #selector(MBFloatScrollButton.dismissMenu), for: .allTouchEvents)
        self.bringSubview(toFront: self.scrollView)
        
        self.scrollView.addSubview(self.maskBackgroundView!)
        
        filterItem1 = FilterItemView(filterType: .nearest)
        filterItem1.frame.origin.x = self.frame.origin.x
        filterItem1.center.y = self.center.y
        filterItem1.delegate = self
        self.maskBackgroundView?.addSubview(filterItem1)
        
        
        filterItem2 = FilterItemView(filterType: .mostLife)
        filterItem2.frame.origin.x = self.frame.origin.x
        filterItem2.center.y = self.center.y
        filterItem2.delegate = self
        self.maskBackgroundView?.addSubview(filterItem2)
        
        filterItem3 = FilterItemView(filterType: .lessLife)
        filterItem3.frame.origin.x = self.frame.origin.x
        filterItem3.center.y = self.center.y
        filterItem3.delegate = self
        self.maskBackgroundView?.addSubview(filterItem3)
        
        filterItem4 = FilterItemView(filterType: .mostVoted)
        filterItem4.frame.origin.x = self.frame.origin.x
        filterItem4.center.y = self.center.y
        filterItem4.delegate = self
        self.maskBackgroundView?.addSubview(filterItem4)

        
        UIView.animate(withDuration: 0.25) {
            self.filterItem1.center.y -= 70
            self.filterItem2.center.y -= 70 * 2
            self.filterItem3.center.y -= 70 * 3
            self.filterItem4.center.y -= 70 * 4
        }
 
    }
    
    func dismissMenu() {
        isShowingMenu = false
        self.scrollView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.25, animations: {
            self.filterItem1.titleLabel.alpha = 0
            self.filterItem2.titleLabel.alpha = 0
            self.filterItem3.titleLabel.alpha = 0
            self.filterItem4.titleLabel.alpha = 0
            self.filterItem1.center.y += 70
            self.filterItem2.center.y += 70 * 2
            self.filterItem3.center.y += 70 * 3
            self.filterItem4.center.y += 70 * 4
        }) { (finished) in
            self.maskBackgroundView?.removeFromSuperview()
            self.filterItem1 = nil
            self.filterItem2 = nil
            self.filterItem3 = nil
            self.filterItem4 = nil
        }
    }

}

extension MBFloatScrollButton : FilterItemViewDelegate {
    func didTap(filter: FilterItemView) {
        self.dismissMenu()
        delegate?.didTap(filter: filter.filterType)
    }
}


protocol MBFloatScrollButtonDelegate :class {
    
    func didTap(button: MBFloatScrollButton)
    
    func didTap(filter: FilterType)
}

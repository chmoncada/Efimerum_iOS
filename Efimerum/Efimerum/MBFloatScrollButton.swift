//
//  MBFloatScrollButton.swift
//  Efimerum
//
//  Created by Michel on 06/02/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class MBFloatScrollButton: UIImageView, UIScrollViewDelegate {
    
    var tagsInteractor : TagsInteractor?

    var hideWhileScrolling = true
    var isFloatActionMenu : Bool = false
    let scrollView :UIScrollView
    var maskBackgroundView :UIControl?
    var delegate :MBFloatScrollButtonDelegate?
    var isHideDirectionUp = false
    var isShowingMenu = false
    
    let parentView :UIView
    
    let floatButtonType :FloatButtonType
    
    private var filterItem1 : FilterItemView!
    private var filterItem2 : FilterItemView!
    private var filterItem3 : FilterItemView!
    private var filterItem4 : FilterItemView!
    
    var searchTextField :UITextField?
    var orderBubbleView :BubbleView?
    var searchBubbleView :BubbleView?
    
    var tagsView :TagsTableView?
 
    
    var previousOffset :CGFloat = 0.0
    var originalPosY :CGFloat = 0.0
    
 
    init(buttonType: FloatButtonType, on scrollView: UIScrollView, for parentView: UIView) {
        self.scrollView = scrollView
        self.parentView = parentView
        self.floatButtonType = buttonType
        previousOffset = self.scrollView.contentOffset.y
        super.init(frame: CGRect.zero)
        
        tagsInteractor = TagsInteractor(interface: self)
        
        setButton(buttonType: buttonType, parentView: parentView)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setButton(buttonType: FloatButtonType, parentView: UIView) {
        
        setupButton()
        
        let size1 = scrollView.bounds.size.width / 10
        let size2 = scrollView.bounds.size.width / 5
        let size3 = scrollView.bounds.size.width - 40 - size1 * 2  - 20
        let size4 = size1 * 2 / 3
        
        switch buttonType {
        case .camera:
            self.frame = CGRect(x: scrollView.bounds.size.width/2 - size2/2,
                          y: scrollView.bounds.size.height - size2 - 20,
                          width: size2,
                          height: size2)
            self.image = UIImage(named: "btnCamera")!
            let tap = UITapGestureRecognizer(target: self, action: #selector(MBFloatScrollButton.tapButtonActionCamera))
            self.addGestureRecognizer(tap)
        case .orderBy:
            self.frame = CGRect(x: scrollView.bounds.origin.x + 20,
                          y: scrollView.bounds.size.height - size1 - 20,
                          width: size1,
                          height: size1)
            self.image = UIImage(named: "btnFilter")!
            setMenuButton()
            let tap = UITapGestureRecognizer(target: self, action: #selector(MBFloatScrollButton.tapButtonActionFilter))
            self.addGestureRecognizer(tap)
            isFloatActionMenu = true
        case .search:
            self.frame = CGRect(x: scrollView.bounds.size.width/2 - size3/2,
                                y: scrollView.bounds.origin.y + 30 + (size1 - size4) / 2,
                                width: size3,
                                height: size4)
                self.layer.cornerRadius = self.bounds.size.height/2
                self.backgroundColor = .white
            setupSearchTextField()
            break
        case .profile:
            
            self.frame = CGRect(x: scrollView.bounds.size.width - size1 - 20,
                   y: scrollView.bounds.size.height - size1 - 20,
                   width: size1,
                   height: size1)
            self.image = UIImage(named: "btnProfile")!
            let tap = UITapGestureRecognizer(target: self, action: #selector(MBFloatScrollButton.tapButtonActionProfile))
            self.addGestureRecognizer(tap)
        case .logo:
            
            self.frame = CGRect(x: scrollView.bounds.origin.x + 20,
                                y: scrollView.bounds.origin.y + 30,
                                width: size1,
                                height: size1)
            self.image = UIImage(named: "flame")!
            hideWhileScrolling = false
        }
        originalPosY = self.center.y
        parentView.addSubview(self)
    }
    
    
    func setMenuButton(){
    
        
        
    }
    
    func setupButton() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.5
     
        if hideWhileScrolling {
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    
    }

    
    func tapButtonActionCamera() {
        
        delegate?.didTapOnCamera(button: self)
    }
    
    
    func tapButtonActionProfile() {
        
        delegate?.didTapOnProfile(button: self)
    }
    
    
    func tapButtonActionFilter() {
        
        if isShowingMenu {
            dismissMenu()
        } else {
            showMenu()
        }
    }
    
    //MARK: - Search textField
    
    fileprivate func setupSearchTextField() {
        
        let frame = CGRect(x: self.bounds.origin.x + 10,
                           y: self.bounds.origin.y + 2,
                           width: self.bounds.size.width - 20,
                           height: self.bounds.size.height - 4)
        searchTextField = UITextField(frame: frame)
        searchTextField?.delegate = self
        searchTextField?.backgroundColor = .white
        searchTextField?.font = UIFont.systemFont(ofSize: 14)
        searchTextField?.placeholder = "Search tags..."
        searchTextField?.addTarget(self, action: #selector(MBFloatScrollButton.textFieldDidChange(_:)), for: .editingChanged)
        self.addSubview(searchTextField!)
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
                    self.orderBubbleView?.alpha = 0.0
                    self.searchBubbleView?.alpha = 0.0
                    if self.floatButtonType == .search {
                        self.center.y = self.originalPosY - 200.0
                    } else {
                        self.center.y = self.originalPosY + 200.0
                    }
                })
            } else {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.center.y = self.originalPosY
                    self.orderBubbleView?.alpha = 1.0
                    self.searchBubbleView?.alpha = 1.0
                })
            }
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let theKeypath = keyPath else {
            return
        }
        
        if theKeypath == "contentOffset" {
            if isShowingMenu {
                self.dismissMenu()
            }
            
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
    
    func addOrderSelectedView(text: String) {

        orderBubbleView?.removeFromSuperview()
        orderBubbleView = BubbleView(text: text)
        
        var posX :CGFloat
        if let tagBubble = searchBubbleView {
            posX = tagBubble.frame.origin.x + tagBubble.bounds.size.width + 10
        } else {
            posX = self.parentView.bounds.origin.x + 200
        }
        
        orderBubbleView?.frame = CGRect(x: posX,
                                        y: self.parentView.bounds.origin.y + 80,
                                        width: orderBubbleView!.bounds.size.width,
                                        height: orderBubbleView!.bounds.size.height)
        orderBubbleView?.deletegate = self
        self.parentView.addSubview(orderBubbleView!)
    }
    
    func addSearchSelectedView(text: String) {
        searchBubbleView?.removeFromSuperview()
        searchBubbleView = BubbleView(text: text)
        searchBubbleView?.frame = CGRect(x: self.parentView.bounds.origin.x + 20,
                                        y: self.parentView.bounds.origin.y + 80,
                                        width: searchBubbleView!.bounds.size.width,
                                        height: searchBubbleView!.bounds.size.height)
        
        searchBubbleView?.backgroundColor = .white
        searchBubbleView?.deletegate = self
        
        if let _ = orderBubbleView {
            let orderPosX = orderBubbleView!.frame.origin.x
            let searchRightPos = searchBubbleView!.frame.size.width
            
            if orderPosX - searchRightPos <= -10 {
                orderBubbleView?.frame.origin.x += abs(orderPosX - searchRightPos)
            }
        }
        
        self.parentView.addSubview(searchBubbleView!)
    }
    
    func addTagSearchView(searchTextField: UITextField, tagsResults model: [String]) {
        
        if self.tagsView == nil {
    
            self.tagsView = TagsTableView(model: model, on: searchTextField)
            self.tagsView?.frame = CGRect(x: self.parentView.bounds.width/2 - searchTextField.bounds.size.width/2,
                                    y: self.parentView.frame.origin.y + 100,
                                    width: searchTextField.bounds.size.width,
                                    height: 300)
            self.parentView.addSubview(tagsView!)
            self.tagsView?.tagDelegate = self
            self.tagsView?.isHidden = false
            
        } else {
            
            self.tagsView?.model = model
            self.tagsView?.reloadData()
            self.tagsView?.isHidden = false
        }
    }

}

extension MBFloatScrollButton :UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            
            delegate?.didTypeSearchChanged(text: text)
            self.tagsInteractor?.getTagWith(query: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text {
            
            if text != "" {
                delegate?.didTapOnSearchDone(text: text)
                textField.text = nil
                addSearchSelectedView(text: text)
            }
            
        }
        
        self.parentView.endEditing(true)
        self.tagsView?.isHidden = true
        return true
    }
    
}

extension MBFloatScrollButton : FilterItemViewDelegate {
    func didTap(filter: FilterItemView) {
        self.dismissMenu()
        delegate?.didTap(filter: filter.filterType)
        
        self.orderBubbleView?.removeFromSuperview()
        self.orderBubbleView = nil
        
        if filter.filterType != .random {
            
            let text = filter.filterType.getText()
            addOrderSelectedView(text: text)
        }
    }
}

extension MBFloatScrollButton :BubbleViewDelegate {
    
    func didTapDismissView(view: BubbleView) {
        if view == self.orderBubbleView {
            delegate?.didTap(filter: .random)
        } else if view == self.searchBubbleView {
            delegate?.didTapOnSearchDone(text: "")
        }
        view.removeFromSuperview()
        
    }
}

extension MBFloatScrollButton :TagsTableViewDelegate {
    
    func didTapOn(tag: String) {
        delegate?.didTapOnSearchDone(text: tag)
        self.searchTextField?.text = nil
        addSearchSelectedView(text: tag)
        self.parentView.endEditing(true)
        self.tagsView?.isHidden = true
    }
}


extension MBFloatScrollButton :TagsInteractorOutput {
    
    func loadObtained(tags: [String]) {
        print(tags)
        addTagSearchView(searchTextField: self.searchTextField!, tagsResults: tags)
    }
}


protocol MBFloatScrollButtonDelegate :class {
    
    func didTapOnCamera(button: MBFloatScrollButton)
    
    func didTapOnProfile(button: MBFloatScrollButton)
    
    func didTap(filter: FilterType)
    
    func didTypeSearchChanged(text: String)
    
    func didTapOnSearchDone(text: String)
    
}




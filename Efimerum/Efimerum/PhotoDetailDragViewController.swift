//
//  PhotoDetailDragViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 07/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16

protocol PhotoDetailDragViewControllerOutput: class {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
    func isNotAuthenticated() -> Bool
    func likeToPhotoWithIdentifier(_ identifier: String)

}

class PhotoDetailDragViewController: UIViewController {

    weak var output: PhotoDetailDragViewControllerOutput!
    
    // MARK: Properties
    
    var model: PhotoWallModelType?
    var didFinish: () -> Void = {}
    var needAuthLogin: (String) -> Void = { _ in }
    var startIndex: Int = 0
    var indexesToDelete: [String] = []
    
    // MARK: UI Components
    
    var kolodaView: CustomKolodaView = {
        let view = CustomKolodaView()
        return view
    }()
    
    let closeButton: UIButton = {
       
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleDismissView), for: .touchUpInside)
        return button
        
    }()
    
    //TEMPORAL BUTTON
    let logoutButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
        
    }()
    
    // MARK: init
    init(model: PhotoWallModelType, startIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.startIndex = startIndex
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupKolodaView()
        view.addSubview(kolodaView)
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        //TEMPORARY BUTTON
        view.addSubview(logoutButton)
        setupLogoutButton()
        
        PhotoDetailDragConfigurator.instance.configure(viewController: self)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController || isBeingDismissed {
            didFinish()
        }
    }
 
}


// MARK: KolodaViewDelegate protocol

extension PhotoDetailDragViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("se me acabaron las cartas")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        handleTouch()
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        let photo = model?.photo(at: startIndex + index)
        let identifier = photo!.identifier
        print(identifier)
        
        switch direction {
        case .left:
            indexesToDelete.append(identifier)
        case .right:
            handleLikePhotoWithIdentifier(identifier)
            indexesToDelete.append(identifier)
        default:
            print("No pasa nada")
        }
    }
    
}

// MARK: KolodaViewDataSource protocol

extension PhotoDetailDragViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return model!.numberOfPhotos - startIndex
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let photo = model?.photo(at: startIndex + index)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (photo?.imageWidth)!, height: (photo?.imageHeight)!))
        
        if let url = photo?.imageURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
        }
        
        return imageView
    }
    
}



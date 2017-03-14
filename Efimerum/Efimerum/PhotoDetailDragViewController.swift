//
//  PhotoDetailDragViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 07/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import pop
import CoreLocation

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16

protocol PhotoDetailDragViewControllerOutput: class {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
    func likeToPhotoWithIdentifier(_ identifier: String, location: CLLocation?)

}

class PhotoDetailDragViewController: UIViewController {

    weak var output: PhotoDetailDragViewControllerOutput!
    
    var didAskPhotoInfo: (Photo) -> Void = { _ in }
    
    lazy var authInteractor: AuthInteractor = {
        let interactor = AuthInteractor.instance
        return interactor
    }()
    
    lazy var userLocationManager: UserLocationManager = {
        let manager = UserLocationManager()
        return manager
    }()
    
    // MARK: Properties
    
    var model: PhotoWallModelType?
    var didFinish: () -> Void = {}
    var needAuthLogin: (String, CLLocation?) -> Void = { _ in }
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
    
    let infoButton: UIButton = {
        let button = UIButton(type: UIButtonType.infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "btn_skip_pressed")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
        
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "btn_like_pressed")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        
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
        view.tintColor = UIColor.white
        
        setupKolodaView()
        view.addSubview(kolodaView)
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        view.addSubview(infoButton)
        setupInfoButton()
        
        view.addSubview(skipButton)
        setupSkipButton()
        
        view.addSubview(likeButton)
        setupLikeButton()
        
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
        handleDismissView()
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
            let when = DispatchTime.now() + 2
            userLocationManager.locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.handleLikePhotoWithIdentifier(identifier, userLocationManager: self.userLocationManager)
                self.indexesToDelete.append(identifier)
            }
            
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



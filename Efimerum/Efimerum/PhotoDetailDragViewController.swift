//
//  PhotoDetailDragViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 07/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
import pop
import FirebaseAuth
//import RxSwift


private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0

protocol PhotoDetailDragViewControllerOutput: class {
    func deletePhotosOfIndexes( _ indexes: [String])
    func logout()
}

class PhotoDetailDragViewController: UIViewController {

    weak var output: PhotoDetailDragViewControllerOutput!
    
    var model: PhotoWallModelType?
    var startIndex: Int = 0
    
    var indexesToDelete: [String] = []
    
    var kolodaView: CustomKolodaView = {
        let view = CustomKolodaView()
        return view
    }()
    
    let closeButton: UIButton = {
       
        let button = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
        
    }()
    
    //TEMPORAL BUTTON
    let logoutButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        
        button.addTarget(self, action: #selector(firebaseLogout), for: .touchUpInside)
        return button
        
    }()
    
    var didFinish: () -> Void = {}
    var needAuthLogin: () -> Void = {}
    
    init(model: PhotoWallModelType, startIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.startIndex = startIndex
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        kolodaView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(kolodaView)
        
        view.addSubview(closeButton)
        setupCloseButton()
        
        //TEMPORARY BUTTON
        view.addSubview(logoutButton)
        setupLogoutButton()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        PhotoDetailDragConfigurator.instance.configure(viewController: self)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController || isBeingDismissed {
            didFinish()
        }
    }

    func dismissView() {
        
        if indexesToDelete.count > 0 {
            output.deletePhotosOfIndexes(indexesToDelete)
        }
        
        let _ = navigationController?.popViewController(animated: false)
    }
    
    func setupCloseButton() {
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // TEMPORAL FUNC
    
    func setupLogoutButton() {
        logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func firebaseLogout() {
        output.logout()
    }
}

extension PhotoDetailDragViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("se me acabaron las cartas")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("me seleccionaron")
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
        
        switch direction {
        case .left:
            print("No me gusto, paso a la siguiente")
            
            let photo = model?.photo(at: startIndex + index)
            let identifier = photo!.identifier
            indexesToDelete.append(identifier)
            
        case .right:
            print("Me gusto, darle like a la foto")
            
            // user is not logged in
            if FIRAuth.auth()?.currentUser?.uid == nil || (FIRAuth.auth()?.currentUser?.isAnonymous)!{
                needAuthLogin()
            } 
            
        default:
            print("No pasa nada")
        }
    }
    
}

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



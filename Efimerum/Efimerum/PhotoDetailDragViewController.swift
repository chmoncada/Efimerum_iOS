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

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0


class PhotoDetailDragViewController: UIViewController {

    var model: PhotoDetailDragModelType?
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var didFinish: () -> Void = {}
    
    var needAuthLogin: () -> Void = {}
    
    init(model: PhotoDetailDragModelType) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController || isBeingDismissed {
            didFinish()
        }
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        
        let _ = navigationController?.popViewController(animated: false)
    
    }
    
    @IBAction func firebaseLogout(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
    }
}

extension PhotoDetailDragViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("se me acabaron las cartas")
        kolodaView.resetCurrentCardIndex()
        
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
        case .right:
            print("Me gusto, darle like a la foto")
            // user is not logged in
            if FIRAuth.auth()?.currentUser?.uid == nil {
                needAuthLogin()
            } else {
                print("Ya estoy logueado")
            }
            
        default:
            print("No pasa nada")
        }
    }
    
}

extension PhotoDetailDragViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return model!.numberOfPhotos
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let image = model?.photo(at: index)
        
        let imageView = UIImageView(image: image)
        
        return imageView
    }
    
}



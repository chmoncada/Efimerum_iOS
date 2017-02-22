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
import RxSwift


private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0


class PhotoDetailDragViewController: UIViewController {

    var model: PhotoWallModelType?
    var startIndex: Int = 0
    
    var indexesToDelete: [String] = []
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
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
        
        if indexesToDelete.count > 0 {
            let container = PhotoContainer.instance
            let observable: Observable<Void>
            observable = container.delete(photosWithIdentifiers: indexesToDelete)
            observable.subscribe().addDisposableTo(DisposeBag())
        } else {
            print("NO HAY NADA QUE BORRAR")
        }
        
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
        //kolodaView.resetCurrentCardIndex()
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



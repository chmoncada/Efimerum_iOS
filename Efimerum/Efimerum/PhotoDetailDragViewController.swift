//
//  PhotoDetailDragViewController.swift
//  EfimerumTestGrid
//
//  Created by Charles Moncada on 07/02/17.
//  Copyright © 2017 Charles Moncada. All rights reserved.
//

import UIKit
//import Koloda
import Photos
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 1
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0


class PhotoDetailDragViewController: UIViewController {

    var assetFetchResults: PHFetchResult<PHAsset>?
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var didFinish: () -> Void = {}
    
    init(assetFetchResults: PHFetchResult<PHAsset> = allElementsFromLibrary()) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.assetFetchResults = assetFetchResults
        
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
        
        print("me apretaron")
        navigationController?.popViewController(animated: false)
        
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
    
}

extension PhotoDetailDragViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return assetFetchResults!.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let asset = self.assetFetchResults?[index]
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .opportunistic
        options.version = .original
        options.isSynchronous = true
        
        var imageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let ratio1 = CGFloat((asset?.pixelWidth)!) / koloda.bounds.width
        let ratio2 = CGFloat((asset?.pixelHeight)!) / koloda.bounds.height
        var ratio3: CGFloat = 0
        
        if ratio1 < ratio2 {
            ratio3 = ratio2
        } else {
            ratio3 = ratio1
        }
        
        
        let requestImageSize = CGSize(width: CGFloat(asset!.pixelWidth) / ratio3, height: CGFloat(asset!.pixelHeight) / ratio3)
        PHCachingImageManager.default().requestImage(for: asset!,
                                                     targetSize: requestImageSize,
                                                     contentMode: PHImageContentMode.aspectFit,
                                                     options: options,
                                                     resultHandler: { (result, info) in
                                                        imageView = UIImageView(image: result)
                                                        
        })
        

        //imageView.backgroundColor = UIColor.white
        
        return imageView
        
        
    }
    
}



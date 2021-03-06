//
//  Utils.swift
//  Efimerum
//
//  Created by Charles Moncada on 19/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

func getRandomKey() -> String {
    
    var randomKey = ""
    let random = Int(arc4random_uniform(4))
    switch random {
    case 0:
        randomKey = "md5"
    case 1:
        randomKey = "randomString"
    case 2:
        randomKey = "sha1"
    case 3:
        randomKey = "sha256"
    default:
        randomKey = "randomString"
    }
    
    return randomKey
}

// MARK: UIColor extension
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPad
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .iPad }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .iPhone6
        }
    }
}

class UtilTime {
    
    static func getDate(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY HH:mm"
 
        return formatter.string(from: date)
    }
    

    fileprivate static func secondsToHoursMinutesSeconds (_ seconds : Double) -> (Int, Int, Int) {
        return (Int(seconds) / 3600, (Int(seconds) % 3600) / 60, (Int(seconds) % 3600) % 60)
    }
}

class UtilTags {
    
    static func getTagsString(tags: [String]) -> String {
        var str = ""
        
        for i in 0..<tags.count {
            if i == tags.count - 1 {
                str = str + "\(tags[i])"
            } else {
                str = str + "\(tags[i]) • "
                
            }
        }
        return str
    }
}









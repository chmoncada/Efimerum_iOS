//
//  UserDefaultsManager.swift
//  Efimerum
//
//  Created by Michel on 13/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    fileprivate let userDefaults :UserDefaults = {
        return UserDefaults.standard
    }()
    
    fileprivate let favoriteTagsKey = "favorites tags"
    
    func markFavorite(tag: String) -> (Bool, Bool) {
        if isFavorite(tag: tag) {
            return (deleteFavorite(tag: tag), false)
        } else {
            return (saveFavorite(tag: tag), true)
        }
    }
    
    func isFavorite(tag: String) -> Bool {
        
        guard let tagsSaved = getFavoritesArray() else {
            return false
        }
        
        for tagItem in tagsSaved {
            if tag == tagItem {
                return true
            }
        }
        
        return false
    }
    
    func getFavoritesArray() -> [String]? {
        let savedTags = userDefaults.object(forKey: favoriteTagsKey) as? [String]
        return savedTags
    }
    
    //MARK: - Private Methods
    
    fileprivate func saveFavorite(tag: String) -> Bool {
        
        guard var tagsSaved = getFavoritesArray() else {
            let tags = [tag]
            userDefaults.set(tags, forKey: favoriteTagsKey)
            userDefaults.synchronize()
            return true
        }
        
        tagsSaved.append(tag)
        userDefaults.set(tagsSaved, forKey: favoriteTagsKey)
        userDefaults.synchronize()
        return true
    }
    
    fileprivate func deleteFavorite(tag: String) -> Bool {
        
        if var tagsSaved = getFavoritesArray() {
            for i in 0...tagsSaved.count {
                if tagsSaved[i] == tag {
                    tagsSaved.remove(at: i)
                    userDefaults.set(tagsSaved, forKey: favoriteTagsKey)
                    userDefaults.synchronize()
                    return true
                }
            }
            
        }

        return false
    }
    
}

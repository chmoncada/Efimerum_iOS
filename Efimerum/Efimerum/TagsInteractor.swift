//
//  TagsInteractor.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 11/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation


protocol TagsInteractorInput :class {
    
    func getSuggestedTagsWith(query: String)
    
    func markFavorite(tag: String) -> (Bool, Bool)
    
    func isFavorite(tag: String) -> Bool
    
    func getFavoriteTags()
}

protocol TagsInteractorOutput : class {
    
    func loadSuggested(tags: [String])
    
    func loadFavorite(tags: [String]?)

}


class TagsInteractor: TagsInteractorInput {
    
    lazy var authManager: FirebaseAuthenticationManager = {
        let manager = FirebaseAuthenticationManager.instance
        return manager
    }()
    
    lazy var userDefaultsManager: UserDefaultsManager = {
        let manager = UserDefaultsManager()
        return manager
    }()
    
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    weak fileprivate var interface :TagsInteractorOutput?
    
    init(interface: TagsInteractorOutput) {

        self.interface = interface
    }
    
    init() {}
    
    func getSuggestedTagsWith(query q: String) {
        
        self.databaseManager.getTagsWith(query: q) { (tags) in
            if let tags = tags {
                print(tags)
                self.interface?.loadSuggested(tags: tags)
            } else {
                self.interface?.loadSuggested(tags: [String]())
            }
        }
    }
    
    func markFavorite(tag: String) -> (Bool, Bool) {
       return userDefaultsManager.markFavorite(tag: tag)
    }
    
    func isFavorite(tag: String) -> Bool {
        return userDefaultsManager.isFavorite(tag: tag)
    }
    
    func getFavoriteTags() {
        let tags = userDefaultsManager.getFavoritesArray()
        self.interface?.loadFavorite(tags: tags)
    }
    
    
}

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
    
}

protocol TagsInteractorOutput : class {
    
    func loadSuggested(tags: [String])

}


class TagsInteractor: TagsInteractorInput {
    
    
    lazy var databaseManager: FirebaseDatabaseManager = {
        let manager = FirebaseDatabaseManager.instance
        return manager
    }()
    
    weak fileprivate var interface :TagsInteractorOutput?
    
    init(interface: TagsInteractorOutput) {

        self.interface = interface
    }
    
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
    
}

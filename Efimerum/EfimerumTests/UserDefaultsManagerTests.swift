//
//  UserDefaultsManagerTests.swift
//  Efimerum
//
//  Created by Michel on 31/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import XCTest

class UserDefaultsManagerTests: XCTestCase {
    
    let userDefaultsManager = UserDefaultsManager()

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        userDefaultsManager.clearFavoritesTags()
    }
    
    
    func testMarkFavoriteTag() {
        
        let favoriteTag = "dog"
        
        let _ = userDefaultsManager.markFavorite(tag: favoriteTag)
        XCTAssertEqual(userDefaultsManager.isFavorite(tag: favoriteTag), true)
        
        let _ = userDefaultsManager.markFavorite(tag: favoriteTag)
        XCTAssertEqual(userDefaultsManager.isFavorite(tag: favoriteTag), false)
        
    }
    
    func testGetFavoriteTagsArray() {
        let dogTag = "dog"
        let _ = userDefaultsManager.markFavorite(tag: dogTag)
        
        let catTag = "cat"
        let _ = userDefaultsManager.markFavorite(tag: catTag)
        
        let cowTag = "cow"
        let _ = userDefaultsManager.markFavorite(tag: cowTag)
        
        let expectedTags = ["dog", "cat", "cow"]
        
        let favoriteTags = userDefaultsManager.getFavoritesArray()!
        
        XCTAssertEqual(favoriteTags, expectedTags)
        
    }
    
}

//
//  PhotoResults.swift
//  Efimerum
//
//  Created by Charles Moncada on 14/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import RealmSwift

public protocol PhotoResultsType {
    
    /// Called when photos are inserted, updated or removed
    var didUpdate: () -> Void { get set }
    
    /// The number of photos in the result set
    var numberOfPhotos: Int { get }
    
    /// Returns the photo at a given index
    func photo(at index: Int) -> Photo
}

internal final class PhotoResults: PhotoResultsType {
    
    // MARK: - VolumeResultsType
    
    var didUpdate: () -> Void = {}
    
    var numberOfPhotos: Int {
        return results.count
    }
    
    func photo(at index: Int) -> Photo {
        
        let entryRealm = results[index]
        
        return Photo(entry: entryRealm)
        
    }
    
    // MARK: - Properties
    private var results: Results<PhotoEntry>
    private var token = NotificationToken()
    
    
    //MARK: - Initialization
    
    init(container: Realm) {
        results = container.objects(PhotoEntry.self)
        
        token = container.addNotificationBlock { [weak self] _, _ in
            self?.didUpdate()
        }
    }
    
    init(container: Realm, randomKey: String) {
        
        results = container.objects(PhotoEntry.self).sorted(byKeyPath: randomKey)
        
        token = container.addNotificationBlock { [weak self] _, _ in
            self?.didUpdate()
        }
    }
    
    init(container: Realm, sortedKey: String, ascending: Bool) {
        
        results = container.objects(PhotoEntry.self).sorted(byKeyPath: sortedKey, ascending: ascending)
        
        token = container.addNotificationBlock { [weak self] _, _ in
            self?.didUpdate()
        }
    }
    
    deinit {
        token.stop()
    }
    
}

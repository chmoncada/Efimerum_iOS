//
//  PhotoContainer.swift
//  Efimerum
//
//  Created by Charles Moncada on 14/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


// A collection of photos persisted in disk
public protocol PhotoContainerType {

    /// Loads the corresponding store for the container
    func load() -> Observable<Void>

    /// Saves an array of photos in the container
    func save(photos: [Photo]) -> Observable<Void>
    
    /// Update an array of photos in the container
    func edit(photos: [Photo]) -> Observable<Void>
    
    func editIfExist(photos: [Photo]) -> Observable<Void>
    
    func delete(photosWithIdentifiers: [String]) -> Observable<Void>

    /// Deletes the photo with a given identifier
    func delete(photoWithIdentifier: String) -> Observable<Void>
    
    /// Deletes all photos in the container
    func deleteAll() -> Observable<Void>

    /// Determines if the container contains a volume with a given identifier
    func contains(photoWithIdentifier: String) -> Bool

    /// Returns all the volumes in the container
    func all() -> PhotoResultsType
    
    /// Returns all the volumes in the container using some randomKey to sort them
    func allRandom(randomKey: String) -> PhotoResultsType
    
    /// Returns all the volumes in the container using some sortedKey to sort them
    func sortedBy(sortedKey: String, ascending: Bool) -> PhotoResultsType
    
}

final public class PhotoContainer {
    
    fileprivate var container: Realm
    
    private init(container: Realm) {
        self.container = container
    }
    
    public convenience init(name: String) {
        
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(name).realm")
        let container = try! Realm(configuration: config)
        
        self.init(container: container)
    }
    
    public static func temporary() -> PhotoContainer {
        
        var config = Realm.Configuration()
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        config.fileURL = temporaryDirectoryURL.appendingPathComponent("\(UUID().uuidString).realm")
        let container = try! Realm(configuration: config)
        
        return PhotoContainer(container: container)
    }

}


extension PhotoContainer: PhotoContainerType {
    
    public func all() -> PhotoResultsType {
        
        return PhotoResults(container: container)
        
    }
    
    public func allRandom(randomKey: String) -> PhotoResultsType {
        
        return PhotoResults(container: container, randomKey: randomKey)
    }
    
    public func sortedBy(sortedKey: String, ascending: Bool) -> PhotoResultsType {
        return PhotoResults(container: container, sortedKey: sortedKey, ascending: ascending)
    }
    
    public func contains(photoWithIdentifier: String) -> Bool {
        
        let predicate = NSPredicate(format: "identifier == %@", photoWithIdentifier)
        let results = container.objects(PhotoEntry.self).filter(predicate)
        
        if results.count > 0 {
            return true
        } else {
            return false
        }
        
    }
    
    public func load() -> Observable<Void> {
        
        return Observable.create { observer in
            
            return Disposables.create()
        }
    }

    public func save(photos: [Photo]) -> Observable<Void> {
        return performBackgroundTask { container in
            try container.write {
                for photo in photos {
                    let photoEntry = PhotoEntry(photo: photo)
                    container.add(photoEntry)
                }
            }
        }
    }
    
    public func edit(photos: [Photo]) -> Observable<Void> {
        return performBackgroundTask { container in
            try container.write {
                for photo in photos {
                    let photoEntry = PhotoEntry(photo: photo)
                    container.add(photoEntry, update: true)
                }
            }
        }
    }
    
    public func editIfExist(photos: [Photo]) -> Observable<Void> {
        return performBackgroundTask { container in
            try container.write {
                for photo in photos {
                    
                    if self.contains(photoWithIdentifier: photo.identifier) {
                        let photoEntry = PhotoEntry(photo: photo)
                        container.add(photoEntry, update: true)
                    }
                    
                }
            }
        }
    }

    
    public func delete(photosWithIdentifiers: [String]) -> Observable<Void> {
        return performBackgroundTask { container in
            var photosToDelete: [PhotoEntry] = []
            for each in photosWithIdentifiers {
                let predicate = NSPredicate(format: "identifier == %@", each)
                if let result = container.objects(PhotoEntry.self).filter(predicate).first {
                    photosToDelete.append(result)
                }
            }
            try container.write {
                container.delete(photosToDelete)
            }
        }

    }
    
    public func delete(photoWithIdentifier: String) -> Observable<Void> {
        return performBackgroundTask { container in
            try container.write {
                let predicate = NSPredicate(format: "identifier == %@", photoWithIdentifier)
                let result = container.objects(PhotoEntry.self).filter(predicate).first
                container.delete(result!)
            }
        }
    }
    
    public func deleteAll() -> Observable<Void> {
        return performBackgroundTask({ (container) in
            try container.write {
                container.deleteAll()
            }
        })
    }
    
    private func performBackgroundTask(_ task: @escaping (Realm) throws -> Void) -> Observable<Void> {
        
        return Observable.create { observer in
            
            do {
                try task(self.container)
                observer.onNext()
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
}

extension PhotoContainer {
    
    static let instance = PhotoContainer(name: "Photos")
    
}

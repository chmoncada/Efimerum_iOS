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

    /// Saves an array of volumes in the container
    func save(photos: [Photo]) -> Observable<Void>

    /// Deletes the volume with a given identifier
    func delete(photoWithIdentifier: Int) -> Observable<Void>

    /// Determines if the container contains a volume with a given identifier
    func contains(photoWithIdentifier: Int) -> Bool

    /// Returns all the volumes in the container
    func all() -> PhotoResultsType
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
    
    public func contains(photoWithIdentifier: Int) -> Bool {
        
        let predicate = NSPredicate(format: "index == %d", photoWithIdentifier)
        let results = container.objects(PhotoEntry.self).filter(predicate)
        
        if results.count > 0 {
            return true
        } else {
            return false
        }
        
    }
    
    public func load() -> Observable<Void> {
        
        return Observable.create { observer in
            
            //            self.container.loadPersistentStores { _, error in
            //                if let error = error {
            //                    observer.onError(error)
            //                } else {
            //                    observer.onNext()
            //                    observer.onCompleted()
            //                }
            //            }
            
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
    
    public func delete(photoWithIdentifier: Int) -> Observable<Void> {
        return performBackgroundTask { container in
            try container.write {
                let predicate = NSPredicate(format: "index == %d", photoWithIdentifier)
                let result = container.objects(PhotoEntry.self).filter(predicate).first
                container.delete(result!)
            }
        }
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

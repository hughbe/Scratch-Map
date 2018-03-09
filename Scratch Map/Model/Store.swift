//
//  Store.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 09/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import CoreData

public final class Store {
    public static let shared = Store()
    private init() {}

    private var _cachedCurrentMap: Map?

    public var currentMap: Map {
        get {
            if let cachedCurrentMap = _cachedCurrentMap {
                return cachedCurrentMap
            }

            func getDefaultMap() -> Map {
                let map = Map(context: context)
                map.name = "Default"
                return map
            }

            guard let url = UserDefaults.standard.url(forKey: "CurrentMap"), let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else {
                return getDefaultMap()
            }

            do {
                return try context.existingObject(with: objectId) as! Map
            } catch {
                return getDefaultMap()
            }
        } set {
            UserDefaults.standard.set(newValue.objectID.uriRepresentation(), forKey: "CurrentMap")
            _cachedCurrentMap = currentMap
        }
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Scratch_Map")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {
  static let shared = CoreDataStack()

  let persistentContainer: NSPersistentContainer
  let backgroundContext: NSManagedObjectContext
  let mainContext: NSManagedObjectContext

  private init() {
    persistentContainer = NSPersistentContainer(name: "CoreDataModel")
    let description = persistentContainer.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType

    persistentContainer.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("was unable to load store \(error!)")
      }
    }

    mainContext = persistentContainer.viewContext

    backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    backgroundContext.parent = mainContext
  }
}

//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import Foundation

public class CoreDataStack {
  public static let shared = CoreDataStack()

  public let persistentContainer: NSPersistentContainer
  public let backgroundContext: NSManagedObjectContext
  public let mainContext: NSManagedObjectContext

  private init() {
    guard let modelURL = Bundle.module.url(forResource: "CoreDataModel", withExtension: "momd") else { fatalError() }
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }

    persistentContainer = NSPersistentContainer(name: "CoreDataModel", managedObjectModel: model)
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

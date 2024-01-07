//
// Created by Maximillian Stabe on 06.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(DiaryExercise)
public class DiaryExercise: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryExercise> {
    return NSFetchRequest<DiaryExercise>(entityName: "DiaryExercise")
  }

  @NSManaged public var name: String
  @NSManaged public var notes: String
  @NSManaged public var diary: DiaryEntry
  @NSManaged public var trainingSets: Set<TrainingSet>
}

// MARK: Generated accessors for trainingSets

public extension DiaryExercise {
  @objc(addTrainingSetsObject:)
  @NSManaged func addToTrainingSets(_ value: TrainingSet)

  @objc(removeTrainingSetsObject:)
  @NSManaged func removeFromTrainingSets(_ value: TrainingSet)

  @objc(addTrainingSets:)
  @NSManaged func addToTrainingSets(_ values: Set<TrainingSet>)

  @objc(removeTrainingSets:)
  @NSManaged func removeFromTrainingSets(_ values: Set<TrainingSet>)
}

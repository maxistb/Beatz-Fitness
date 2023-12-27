//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Exercise)
public class Exercise: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
    return NSFetchRequest<Exercise>(entityName: "Exercise")
  }

  @NSManaged public var id: UUID?
  @NSManaged public var category: String?
  @NSManaged public var name: String?
  @NSManaged public var countSets: Int16
  @NSManaged public var notes: String?
  @NSManaged public var exerciseSets: NSSet?
  @NSManaged public var exerciseSplit: Split?
  @NSManaged public var exerciseDiaryEntry: DiaryEntry?
}

// MARK: Generated accessors for exerciseSets

public extension Exercise {
  @objc(addExerciseSetsObject:)
  @NSManaged func addToExerciseSets(_ value: TrainingSet)

  @objc(removeExerciseSetsObject:)
  @NSManaged func removeFromExerciseSets(_ value: TrainingSet)

  @objc(addExerciseSets:)
  @NSManaged func addToExerciseSets(_ values: NSSet)

  @objc(removeExerciseSets:)
  @NSManaged func removeFromExerciseSets(_ values: NSSet)
}

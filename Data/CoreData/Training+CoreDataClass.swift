//
// Created by Maximillian Stabe on 08.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Training)
public class Training: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Training> {
    return NSFetchRequest<Training>(entityName: "Training")
  }

  @NSManaged public var bodyWeight: String
  @NSManaged public var date: Date
  @NSManaged public var endTraining: Date?
  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var notes: String
  @NSManaged public var exercises: Set<Exercise>
  @NSManaged public var split: Split

  public var exerciseArray: [Exercise] {
    exercises.sorted { $0.order < $1.order }
  }

  class func createTraining(
    split: Split
  ) -> Training {
    let training = Training(context: CoreDataStack.shared.mainContext)
    training.bodyWeight = ""
    training.date = .now
    training.endTraining = nil
    training.id = UUID()
    training.name = split.name
    training.notes = ""
    training.exercises = []
    training.split = split

    return training
  }
}

// MARK: Generated accessors for exercises

public extension Training {
  @objc(insertObject:inExercisesAtIndex:)
  @NSManaged func insertIntoExercises(_ value: Exercise, at idx: Int)

  @objc(removeObjectFromExercisesAtIndex:)
  @NSManaged func removeFromExercises(at idx: Int)

  @objc(insertExercises:atIndexes:)
  @NSManaged func insertIntoExercises(_ values: [Exercise], at indexes: NSIndexSet)

  @objc(removeExercisesAtIndexes:)
  @NSManaged func removeFromExercises(at indexes: NSIndexSet)

  @objc(replaceObjectInExercisesAtIndex:withObject:)
  @NSManaged func replaceExercises(at idx: Int, with value: Exercise)

  @objc(replaceExercisesAtIndexes:withExercises:)
  @NSManaged func replaceExercises(at indexes: NSIndexSet, with values: [Exercise])

  @objc(addExercisesObject:)
  @NSManaged func addToExercises(_ value: Exercise)

  @objc(removeExercisesObject:)
  @NSManaged func removeFromExercises(_ value: Exercise)

  @objc(addExercises:)
  @NSManaged func addToExercises(_ values: NSOrderedSet)

  @objc(removeExercises:)
  @NSManaged func removeFromExercises(_ values: NSOrderedSet)
}

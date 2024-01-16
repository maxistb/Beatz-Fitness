//
// Created by Maximillian Stabe on 08.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(Split)
public class Split: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Split> {
    return NSFetchRequest<Split>(entityName: "Split")
  }

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var notes: String
  @NSManaged public var order: Int16
  @NSManaged public var exercises: Set<Exercise>
  @NSManaged public var lastTraining: Training?

  public var exerciseArray: [Exercise] {
    exercises.sorted { $0.order < $1.order }
  }

  public class func createSplit(
    name: String,
    notes: String,
    lastTraining: Training?,
    exercises: Set<Exercise>,
    order: Int16
  ) {
    let newSplit = Split(context: CoreDataStack.shared.mainContext)
    newSplit.id = UUID()
    newSplit.name = name
    newSplit.notes = notes
    newSplit.lastTraining = lastTraining
    newSplit.exercises = exercises
    newSplit.order = order

    try? CoreDataStack.shared.mainContext.save()
  }
}

// MARK: Generated accessors for exercises

public extension Split {
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

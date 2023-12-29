//
// Created by Maximillian Stabe on 27.12.23.
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
  @NSManaged public var splitLastDiaryEntry: DiaryEntry?
  @NSManaged public var splitExercises: [Exercise]
  @NSManaged public var order: Int16

  class func createSplit(
    name: String,
    notes: String,
    splitLastDiaryEntry: DiaryEntry?,
    splitExercises: [Exercise],
    order: Int16
  ) {
    let newSplit = Split(context: CoreDataStack.shared.mainContext)
    newSplit.id = UUID()
    newSplit.name = name
    newSplit.notes = notes
    newSplit.splitLastDiaryEntry = splitLastDiaryEntry
    newSplit.splitExercises = splitExercises
    newSplit.order = order

    try? CoreDataStack.shared.mainContext.save()
  }
}

// MARK: Generated accessors for splitExercises

public extension Split {
  @objc(insertObject:inSplitExercisesAtIndex:)
  @NSManaged func insertIntoSplitExercises(_ value: Exercise, at idx: Int)

  @objc(removeObjectFromSplitExercisesAtIndex:)
  @NSManaged func removeFromSplitExercises(at idx: Int)

  @objc(insertSplitExercises:atIndexes:)
  @NSManaged func insertIntoSplitExercises(_ values: [Exercise], at indexes: NSIndexSet)

  @objc(removeSplitExercisesAtIndexes:)
  @NSManaged func removeFromSplitExercises(at indexes: NSIndexSet)

  @objc(replaceObjectInSplitExercisesAtIndex:withObject:)
  @NSManaged func replaceSplitExercises(at idx: Int, with value: Exercise)

  @objc(replaceSplitExercisesAtIndexes:withSplitExercises:)
  @NSManaged func replaceSplitExercises(at indexes: NSIndexSet, with values: [Exercise])

  @objc(addSplitExercisesObject:)
  @NSManaged func addToSplitExercises(_ value: Exercise)

  @objc(removeSplitExercisesObject:)
  @NSManaged func removeFromSplitExercises(_ value: Exercise)

  @objc(addSplitExercises:)
  @NSManaged func addToSplitExercises(_ values: NSOrderedSet)

  @objc(removeSplitExercises:)
  @NSManaged func removeFromSplitExercises(_ values: NSOrderedSet)
}

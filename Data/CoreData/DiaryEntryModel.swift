//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(DiaryEntry)
public class DiaryEntry: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntry> {
    return NSFetchRequest<DiaryEntry>(entityName: "DiaryEntry")
  }

  @NSManaged public var date: Date?
  @NSManaged public var endTraining: Date?
  @NSManaged public var duration: Double
  @NSManaged public var id: UUID?
  @NSManaged public var bodyWeight: Double
  @NSManaged public var name: String?
  @NSManaged public var notes: String?
  @NSManaged public var diarySplit: Split?
  @NSManaged public var diaryExercises: NSOrderedSet?
}

// MARK: Generated accessors for diaryExercises

public extension DiaryEntry {
  @objc(insertObject:inDiaryExercisesAtIndex:)
  @NSManaged func insertIntoDiaryExercises(_ value: Exercise, at idx: Int)

  @objc(removeObjectFromDiaryExercisesAtIndex:)
  @NSManaged func removeFromDiaryExercises(at idx: Int)

  @objc(insertDiaryExercises:atIndexes:)
  @NSManaged func insertIntoDiaryExercises(_ values: [Exercise], at indexes: NSIndexSet)

  @objc(removeDiaryExercisesAtIndexes:)
  @NSManaged func removeFromDiaryExercises(at indexes: NSIndexSet)

  @objc(replaceObjectInDiaryExercisesAtIndex:withObject:)
  @NSManaged func replaceDiaryExercises(at idx: Int, with value: Exercise)

  @objc(replaceDiaryExercisesAtIndexes:withDiaryExercises:)
  @NSManaged func replaceDiaryExercises(at indexes: NSIndexSet, with values: [Exercise])

  @objc(addDiaryExercisesObject:)
  @NSManaged func addToDiaryExercises(_ value: Exercise)

  @objc(removeDiaryExercisesObject:)
  @NSManaged func removeFromDiaryExercises(_ value: Exercise)

  @objc(addDiaryExercises:)
  @NSManaged func addToDiaryExercises(_ values: NSOrderedSet)

  @objc(removeDiaryExercises:)
  @NSManaged func removeFromDiaryExercises(_ values: NSOrderedSet)
}

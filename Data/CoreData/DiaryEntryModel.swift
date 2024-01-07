//
// Created by Maximillian Stabe on 06.01.24.
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

  @NSManaged public var bodyWeight: String
  @NSManaged public var date: Date
  @NSManaged public var duration: String
  @NSManaged public var endTraining: Date
  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var notes: String
  @NSManaged public var diaryExercises: Set<DiaryExercise>
  @NSManaged public var diarySplit: Split
}

// MARK: Generated accessors for diaryExercises

public extension DiaryEntry {
  @objc(insertObject:inDiaryExercisesAtIndex:)
  @NSManaged func insertIntoDiaryExercises(_ value: DiaryExercise, at idx: Int)

  @objc(removeObjectFromDiaryExercisesAtIndex:)
  @NSManaged func removeFromDiaryExercises(at idx: Int)

  @objc(insertDiaryExercises:atIndexes:)
  @NSManaged func insertIntoDiaryExercises(_ values: [DiaryExercise], at indexes: NSIndexSet)

  @objc(removeDiaryExercisesAtIndexes:)
  @NSManaged func removeFromDiaryExercises(at indexes: NSIndexSet)

  @objc(replaceObjectInDiaryExercisesAtIndex:withObject:)
  @NSManaged func replaceDiaryExercises(at idx: Int, with value: DiaryExercise)

  @objc(replaceDiaryExercisesAtIndexes:withDiaryExercises:)
  @NSManaged func replaceDiaryExercises(at indexes: NSIndexSet, with values: [DiaryExercise])

  @objc(addDiaryExercisesObject:)
  @NSManaged func addToDiaryExercises(_ value: DiaryExercise)

  @objc(removeDiaryExercisesObject:)
  @NSManaged func removeFromDiaryExercises(_ value: DiaryExercise)

  @objc(addDiaryExercises:)
  @NSManaged func addToDiaryExercises(_ values: Set<DiaryExercise>)

  @objc(removeDiaryExercises:)
  @NSManaged func removeFromDiaryExercises(_ values: Set<DiaryExercise>)
}

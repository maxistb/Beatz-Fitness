//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
//

import CoreData
import Foundation

@objc(TrainingSet)
public class TrainingSet: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingSet> {
    return NSFetchRequest<TrainingSet>(entityName: "TrainingSet")
  }

  @NSManaged public var date: Date?
  @NSManaged public var id: UUID?
  @NSManaged public var weight: Double
  @NSManaged public var reps: Double
  @NSManaged public var isWarmup: Bool
  @NSManaged public var isDropset: Double
  @NSManaged public var category: String?
  @NSManaged public var calories: Int16
  @NSManaged public var minutes: Int16
  @NSManaged public var seconds: Int16
  @NSManaged public var notes: String?
  @NSManaged public var distanceKM: Double
  @NSManaged public var exerciseName: String?
  @NSManaged public var setExercise: Exercise?
  @NSManaged public var setDiaryEntry: DiaryEntry?
}

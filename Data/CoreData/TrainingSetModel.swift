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

  @NSManaged public var id: UUID
  @NSManaged public var weight: String
  @NSManaged public var reps: String
  @NSManaged public var isWarmup: Bool
  @NSManaged public var isDropset: Bool
  @NSManaged public var category: String
  @NSManaged public var calories: String
  @NSManaged public var minutes: String
  @NSManaged public var seconds: String
  @NSManaged public var notes: String
  @NSManaged public var distanceKM: String
  @NSManaged public var setExercise: Exercise
  @NSManaged public var setDiaryEntry: DiaryEntry?

  class func createTrainingSet(exercise: Exercise) -> TrainingSet {
    let trainingSet = TrainingSet(context: CoreDataStack.shared.mainContext)
    trainingSet.id = UUID()
    trainingSet.weight = ""
    trainingSet.reps = ""
    trainingSet.isWarmup = false
    trainingSet.isDropset = false
    trainingSet.category = exercise.category
    trainingSet.calories = ""
    trainingSet.minutes = ""
    trainingSet.seconds = ""
    trainingSet.notes = ""
    trainingSet.distanceKM = ""
    trainingSet.setExercise = exercise
    trainingSet.setDiaryEntry = nil

    return trainingSet
  }

  class func deleteTrainingSet(trainingSet: TrainingSet) {
    CoreDataStack.shared.mainContext.delete(trainingSet)
    try? CoreDataStack.shared.mainContext.save()
  }
}

//
// Created by Maximillian Stabe on 08.01.24.
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

  @NSManaged public var calories: String
  @NSManaged public var caloriesPlaceholder: String
  @NSManaged public var category: String
  @NSManaged public var date: Date
  @NSManaged public var distanceKM: String
  @NSManaged public var distanceKMPlaceholder: String
  @NSManaged public var id: UUID
  @NSManaged public var isDropset: Bool
  @NSManaged public var isWarmup: Bool
  @NSManaged public var minutes: String
  @NSManaged public var minutesPlaceholder: String
  @NSManaged public var notes: String
  @NSManaged public var notesPlaceholder: String
  @NSManaged public var order: Int16
  @NSManaged public var reps: String
  @NSManaged public var repsPlaceholder: String
  @NSManaged public var seconds: String
  @NSManaged public var secondsPlaceholder: String
  @NSManaged public var weight: String
  @NSManaged public var weightPlaceholder: String
  @NSManaged public var exercise: Exercise

  class func createTrainingSet(exercise: Exercise, order: Int) -> TrainingSet {
    let trainingSet = TrainingSet(context: CoreDataStack.shared.mainContext)
    trainingSet.calories = ""
    trainingSet.caloriesPlaceholder = ""
    trainingSet.category = exercise.category
    trainingSet.date = .now
    trainingSet.distanceKM = ""
    trainingSet.distanceKMPlaceholder = ""
    trainingSet.id = UUID()
    trainingSet.isDropset = false
    trainingSet.isWarmup = false
    trainingSet.minutes = ""
    trainingSet.minutesPlaceholder = ""
    trainingSet.notes = ""
    trainingSet.notesPlaceholder = ""
    trainingSet.order = Int16(order)
    trainingSet.reps = ""
    trainingSet.repsPlaceholder = ""
    trainingSet.seconds = ""
    trainingSet.secondsPlaceholder = ""
    trainingSet.weight = ""
    trainingSet.weightPlaceholder = ""
    trainingSet.exercise = exercise

    return trainingSet
  }

  class func deleteTrainingSet(trainingSet: TrainingSet) {
    CoreDataStack.shared.mainContext.delete(trainingSet)
    try? CoreDataStack.shared.mainContext.save()
  }
}

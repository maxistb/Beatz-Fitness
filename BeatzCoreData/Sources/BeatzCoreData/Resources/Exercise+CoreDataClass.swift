//
// Created by Maximillian Stabe on 08.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable function_parameter_count

import CoreData
import Foundation

@objc(Exercise)
public class Exercise: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
    return NSFetchRequest<Exercise>(entityName: "Exercise")
  }

  @NSManaged public var category: String
  @NSManaged public var countSets: Int16
  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var notes: String
  @NSManaged public var order: Int16
  @NSManaged public var trainingSets: Set<TrainingSet>
  @NSManaged public var split: Split?
  @NSManaged public var training: Training?

  public var exerciseTrainingSetArray: [TrainingSet] {
    return trainingSets.sorted {
      $0.order < $1.order
    }
  }

  public class func createExercise(
    name: String,
    category: String,
    countSets: Int,
    notes: String,
    order: Int,
    split: Split
  ) {
    let newExercise = Exercise(context: CoreDataStack.shared.mainContext)
    newExercise.id = UUID()
    newExercise.name = name
    newExercise.category = category
    newExercise.countSets = Int16(countSets)
    newExercise.order = Int16(order)
    newExercise.notes = notes
    newExercise.split = split
    newExercise.training = nil

    try? CoreDataStack.shared.mainContext.save()
  }

  public class func createTrainingExercise(
    name: String,
    category: String,
    countSets: Int,
    notes: String,
    order: Int
  ) -> Exercise {
    let newExercise = Exercise(context: CoreDataStack.shared.mainContext)
    newExercise.id = UUID()
    newExercise.name = name
    newExercise.category = category
    newExercise.countSets = Int16(countSets)
    newExercise.order = Int16(order)
    newExercise.notes = notes
    newExercise.split = nil

    try? CoreDataStack.shared.mainContext.save()

    return newExercise
  }
}

// MARK: Generated accessors for trainingSets

public extension Exercise {
  @objc(addTrainingSetsObject:)
  @NSManaged func addToTrainingSets(_ value: TrainingSet)

  @objc(removeTrainingSetsObject:)
  @NSManaged func removeFromTrainingSets(_ value: TrainingSet)

  @objc(addTrainingSets:)
  @NSManaged func addToTrainingSets(_ values: NSSet)

  @objc(removeTrainingSets:)
  @NSManaged func removeFromTrainingSets(_ values: NSSet)
}

// swiftlint:enable function_parameter_count

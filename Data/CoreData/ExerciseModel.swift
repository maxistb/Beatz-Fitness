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

  @NSManaged public var id: UUID
  @NSManaged public var category: String
  @NSManaged public var name: String
  @NSManaged public var countSets: Int16
  @NSManaged public var order: Int16
  @NSManaged public var notes: String
  @NSManaged public var imageURL: String?
  @NSManaged public var exerciseSets: [TrainingSet]
  @NSManaged public var exerciseSplit: Split

  class func createExercise(
    name: String,
    category: String,
    countSets: Int,
    notes: String,
    order: Int,
    exerciseSplit: Split
  ) {
    let newExercise = Exercise(context: CoreDataStack.shared.mainContext)
    newExercise.id = UUID()
    newExercise.name = name
    newExercise.category = category
    newExercise.countSets = Int16(countSets)
    newExercise.order = Int16(order)
    newExercise.notes = notes
    newExercise.exerciseSets = []
    newExercise.exerciseSplit = exerciseSplit

    try? CoreDataStack.shared.mainContext.save()
  }
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

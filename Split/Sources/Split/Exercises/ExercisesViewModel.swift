//
// Created by Maximillian Stabe on 28.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Foundation
import SwiftUI

final class ExercisesViewModel: ObservableObject {
  static let shared = ExercisesViewModel()

  private init() {}

  func createExerciseForSplit(name: String, category: String, countSets: Int, notes: String, split: Split) {
    let newOrder = split.exercises.count
    Exercise.createExercise(
      name: name,
      category: category,
      countSets: countSets,
      notes: notes,
      order: newOrder,
      split: split)
  }

  func deleteExercise(exercises: Set<Exercise>, indicesToDelete: IndexSet) {
    for indexToDelete in indicesToDelete {
      for exercise in exercises {
        if exercise.order > indexToDelete {
          exercise.order -= 1
        } else if exercise.order == indexToDelete {
          CoreDataStack.shared.mainContext.delete(exercise)
        }
      }
    }
    try? CoreDataStack.shared.mainContext.save()
  }

  func moveExercise(exercises: Set<Exercise>, oldIndices: IndexSet, newIndex: Int) {
    var exerciseArray = Array(exercises).sorted { $0.order < $1.order }
    exerciseArray.move(fromOffsets: oldIndices, toOffset: newIndex)
    for (index, exercise) in exerciseArray.enumerated() {
      exercise.order = Int16(index)
    }
    try? CoreDataStack.shared.mainContext.save()
  }
}

//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

class TrainingViewModel: ObservableObject {
  @Published var notes: String = ""
  @Published var bodyWeight: String = ""

  init(notes: String = "", bodyWeight: String = "") {
    self.notes = notes
    self.bodyWeight = bodyWeight
  }

  func deleteSet(exercise: Exercise, indexSet: IndexSet) {
    var setArray = Array(exercise.exerciseSets).sorted { $0.order < $1.order }
    setArray.remove(atOffsets: indexSet)
    for (index, exerciseSet) in setArray.enumerated() {
      exerciseSet.order = Int16(index)
    }
    exercise.countSets -= 1

    try? CoreDataStack.shared.mainContext.save()
  }

  func addTrainingSet(exercise: Exercise) {
    let newOrder = Int(exercise.countSets)
    exercise.addToExerciseSets(TrainingSet.createTrainingSet(exercise: exercise, order: newOrder))
    exercise.countSets += 1

    try? CoreDataStack.shared.mainContext.save()
  }

  func saveTraining(exercises: [Exercise]) {
    for exercise in exercises {}
  }
}

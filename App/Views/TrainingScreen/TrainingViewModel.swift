//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

class TrainingViewModel: ObservableObject {
  @Published var bodyWeight: String
  @Published var notes: String
  @Published var showSwapExerciseSheet: Bool
  @Published var showExerciseBottomSheet: Bool
  @Published var showTimer: Bool
  @Published var showAlert: Bool
  @Published var alertCase: TrainingScreenAlerts = .notDecimalInput
  @Published var forceViewUpdate: Bool
  @Published var copyExercises: Set<Exercise> = []
  @Published var currentSplit: Split
  private let startingTime: Date

  var copyExerciseArray: [Exercise] {
    copyExercises.sorted { $0.order < $1.order }
  }

  init(split: Split) {
    self.currentSplit = split
    self.bodyWeight = ""
    self.notes = ""
    self.showSwapExerciseSheet = false
    self.showExerciseBottomSheet = false
    self.showTimer = false
    self.showAlert = false
    self.alertCase = .notDecimalInput
    self.forceViewUpdate = false
    self.startingTime = .now
    self.copyExercises = createExerciseCopy()
  }

  private func createExerciseCopy() -> Set<Exercise> {
    var copying: Set<Exercise> = []
    for exercise in currentSplit.exercises {
      let exerciseCopy = Exercise.createTrainingExercise(
        name: exercise.name,
        category: exercise.category,
        countSets: Int(exercise.countSets),
        notes: exercise.notes,
        order: Int(exercise.order)
      )
      copying.insert(exerciseCopy)
    }

    return copying
  }

  private func saveExercisesForTraining(training: Training) {
    for exercise in copyExercises {
      exercise.training = training
    }
  }
}

// MARK: - Public Functions

extension TrainingViewModel {
  func deleteSet(exercise: Exercise, indexSet: IndexSet, isInitial: Bool = false) {
    withAnimation {
      exercise.trainingSets.removeFirst()
      for (index, exerciseSet) in exercise.exerciseTrainingSetArray.enumerated() {
        exerciseSet.order = Int16(index)
      }

      if !isInitial { exercise.countSets -= 1 }
      forceViewUpdate.toggle()
    }
    try? CoreDataStack.shared.mainContext.save()
  }

  func addTrainingSet(exercise: Exercise, isInitial: Bool = false) {
    withAnimation {
      let newOrder = Int(exercise.trainingSets.count)
      exercise.addToTrainingSets(TrainingSet.createTrainingSet(exercise: exercise, order: newOrder))

      if !isInitial { exercise.countSets += 1 }
      forceViewUpdate.toggle()
    }

    try? CoreDataStack.shared.mainContext.save()
  }

  func saveTraining(split: Split) {
    let training = Training.createTraining(split: split)
    training.bodyWeight = bodyWeight
    training.date = startingTime
    training.endTraining = .now
    training.notes = notes
    saveExercisesForTraining(training: training)

    try? CoreDataStack.shared.mainContext.save()
  }

  func initializeTrainingSets(split: Split) {
    for splitExercise in copyExerciseArray {
      let exerciseCount = splitExercise.trainingSets.count
      let targetCount = Int(splitExercise.countSets)

      // init or remove more sets if they have been changed
      switch exerciseCount {
      case targetCount:
        continue
      case _ where exerciseCount < targetCount:
        for _ in exerciseCount ..< targetCount {
          addTrainingSet(exercise: splitExercise, isInitial: true)
        }
      case _ where exerciseCount > targetCount:
        for index in targetCount ..< exerciseCount {
          deleteSet(exercise: splitExercise, indexSet: IndexSet(integer: index), isInitial: true)
        }
      default:
        break
      }
    }
  }
}

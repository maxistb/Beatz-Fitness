//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

class TrainingViewModel: ObservableObject {
  @Published var bodyWeight: String = ""
  @Published var notes: String = ""
  @Published var showSwapExerciseSheet: Bool = false
  @Published var showExerciseBottomSheet: Bool = false
  @Published var showTimer: Bool = false
  @Published var showAlert: Bool = false
  @Published var alertCase: TrainingScreenAlerts = .notDecimalInput
  @Published var forceViewUpdate: Bool = false
  @Published var copyExercises: Set<Exercise> = []
  @Published var currentSplit: Split
  private let startingTime: Date

  var copyExerciseArray: [Exercise] {
    copyExercises.sorted { $0.order < $1.order }
  }

  init(split: Split) {
    self.currentSplit = split
    self.startingTime = Date.now
    self.copyExercises = createExerciseCopy(from: split.exercises)
  }

  private func createExerciseCopy(from exercises: Set<Exercise>) -> Set<Exercise> {
    var localCopy: Set<Exercise> = []
    for exercise in currentSplit.exercises {
      let exerciseCopy = Exercise.createTrainingExercise(
        name: exercise.name,
        category: exercise.category,
        countSets: Int(exercise.countSets),
        notes: exercise.notes,
        order: Int(exercise.order)
      )
      localCopy.insert(exerciseCopy)
    }

    return localCopy
  }

  private func saveExercisesForTraining(_ training: Training) {
    for exercise in copyExercises {
      exercise.training = training
    }
  }
}

// MARK: - Public Functions

extension TrainingViewModel {
  func deleteSet(exercise: Exercise, indexSet: IndexSet, isInitial: Bool = false) {
    if !exercise.trainingSets.isEmpty {
      withAnimation {
        exercise.trainingSets.removeFirst()
        exercise.exerciseTrainingSetArray.enumerated().forEach { index, exerciseSet in
          exerciseSet.order = Int16(index)
        }

        if !isInitial { exercise.countSets -= 1 }
        forceViewUpdate.toggle()
      }
      try? CoreDataStack.shared.mainContext.save()
    }
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
    training.endTraining = Date.now
    training.notes = notes
    saveExercisesForTraining(training)

    try? CoreDataStack.shared.mainContext.save()
  }

  func initializeTrainingSets(split: Split) {
    for splitExercise in copyExerciseArray {
      let exerciseCount = splitExercise.trainingSets.count
      let targetCount = Int(splitExercise.countSets)

      // Initiate or remove sets if they have been changed
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

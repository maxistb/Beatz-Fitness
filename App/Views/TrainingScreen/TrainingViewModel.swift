//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

class TrainingViewModel: ObservableObject {
  @Published var notes: String
  @Published var bodyWeight: String
  @Published var showSwapExerciseSheet: Bool
  @Published var showExerciseBottomSheet: Bool
  @Published var showTimer: Bool
  @Published var showAlert: Bool
  @Published var alertCase: TrainingScreenAlerts = .notDecimalInput
  @Published var forceViewUpdate: Bool

  init() {
    self.notes = ""
    self.bodyWeight = ""
    self.showSwapExerciseSheet = false
    self.showExerciseBottomSheet = false
    self.showTimer = false
    self.showAlert = false
    self.alertCase = .notDecimalInput
    self.forceViewUpdate = false
  }

  func deleteSet(exercise: Exercise, indexSet: IndexSet) {
    withAnimation {
      exercise.trainingSets.removeFirst()
      for (index, exerciseSet) in exercise.exerciseTrainingSetArray.enumerated() {
        exerciseSet.order = Int16(index)
      }

      forceViewUpdate.toggle()
    }
    try? CoreDataStack.shared.mainContext.save()
  }

  func addTrainingSet(exercise: Exercise) {
    withAnimation {
      let newOrder = Int(exercise.trainingSets.count)
      exercise.addToTrainingSets(TrainingSet.createTrainingSet(exercise: exercise, order: newOrder))

      forceViewUpdate.toggle()
    }

    try? CoreDataStack.shared.mainContext.save()
  }

  func saveTraining(exercises: [Exercise]) {
    for exercise in exercises {}
  }

  func initializeTraining() {
    
  }
}

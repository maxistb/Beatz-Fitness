//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Foundation
import SwiftUI

class GeneralStatisticViewModel: ObservableObject {
  @Published var currentSelection: GeneralStatisticChart.Selection = .threeMonths

  func updatePredicate(trainings: FetchedResults<Training>) {
    if currentSelection == .all {
      trainings.nsPredicate = nil
    } else {
      trainings.nsPredicate = NSPredicate(
        format: "date >= %@",
        Calendar.current.date(byAdding: .month, value: currentSelection.number, to: Date())! as CVarArg
      )
    }
  }

  func calculateVolume(for training: Training) -> Double {
    var totalWeight: Double = 0
    var totalReps: Double = 0
    for exercise in training.exerciseArray {
      for trainingSet in exercise.exerciseTrainingSetArray {
        totalWeight += Double(trainingSet.weight) ?? 0
        totalReps += Double(trainingSet.reps) ?? 0
      }
    }

    return totalReps * totalWeight
  }

  func calculateSetsPerTraining(for training: Training) -> Double {
    var numberSets: Double = 0
    for exercise in training.exerciseArray {
      numberSets += Double(exercise.countSets)
    }
    return numberSets
  }

  func calculateRepsPerTraining(for training: Training) -> Double {
    var numberReps: Double = 0
    for exercise in training.exerciseArray {
      for trainingSet in exercise.exerciseTrainingSetArray {
        numberReps += Double(trainingSet.reps) ?? 0
      }
    }
    return numberReps
  }
}

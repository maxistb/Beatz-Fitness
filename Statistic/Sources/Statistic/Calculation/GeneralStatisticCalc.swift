//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Foundation

class GeneralStatisticCalc {
  static let shared = GeneralStatisticCalc()

  private init() {}

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

//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

class AllStatisticViewModel: ObservableObject {
  @Published var beginDate: Date = .now
  @Published var endDate: Date = .now

  // compute with day - 1, since otherwhise it wouldn't register trainings on same day as beginTraining
  var adjustedBeginDate: Date {
    Calendar.current.date(byAdding: .day, value: -1, to: beginDate) ?? .now
  }

  func updatePredicate(trainings: FetchedResults<Training>) {
    trainings.nsPredicate = NSPredicate(
      format: "date >= %@ AND date <= %@",
      argumentArray: [adjustedBeginDate, endDate]
    )
  }

  func calculateAllTrainingDuration(for trainings: FetchedResults<Training>) -> String {
    var totalDurationMinutes: Double = 0
    for training in trainings {
      totalDurationMinutes += Double(training.durationMinutes)
    }

    let durationHours = totalDurationMinutes / 60
    let durationDays = durationHours / 24

    return String(format: "%.2f", durationDays) + " Tage"
  }

  func calculateNumberTrainings(for trainings: FetchedResults<Training>) -> String {
    return String(trainings.count)
  }

  func calculateAllWeight(for trainings: FetchedResults<Training>) -> String {
    var allWeight: Double = 0

    for training in trainings {
      for exercise in training.exerciseArray {
        for trainingSet in exercise.trainingSets {
          allWeight += Double(trainingSet.weight) ?? 0
        }
      }
    }

    let allWeightInT = allWeight / 1000

    return String(format: "%.2f", allWeightInT) + "t"
  }

  func calculateAllReps(for trainings: FetchedResults<Training>) -> String {
    var allReps: Double = 0

    for training in trainings {
      for exercise in training.exerciseArray {
        for trainingSet in exercise.trainingSets {
          allReps += Double(trainingSet.reps) ?? 0
        }
      }
    }

    return String(format: "%.2f", allReps)
  }

  func calculateAllSets(for trainings: FetchedResults<Training>) -> String {
    var allSets = 0

    for training in trainings {
      for exercise in training.exerciseArray {
        allSets += Int(exercise.countSets)
      }
    }

    return String(allSets)
  }

  func calculateDistance(for trainings: FetchedResults<Training>) -> String {
    var distanceKM: Double = 0

    for training in trainings {
      for exercise in training.exerciseArray {
        for trainingSet in exercise.trainingSets {
          distanceKM += Double(trainingSet.distanceKM) ?? 0
        }
      }
    }

    return String(format: "%.2f", distanceKM) + "km"
  }

  func calculateCalories(for trainings: FetchedResults<Training>) -> String {
    var calories = 0

    for training in trainings {
      for exercise in training.exerciseArray {
        for trainingSet in exercise.trainingSets {
          calories += Int(trainingSet.calories) ?? 0
        }
      }
    }

    return String(calories)
  }
}

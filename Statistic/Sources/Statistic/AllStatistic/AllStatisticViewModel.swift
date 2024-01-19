//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

class AllStatisticViewModel: ObservableObject {

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
}

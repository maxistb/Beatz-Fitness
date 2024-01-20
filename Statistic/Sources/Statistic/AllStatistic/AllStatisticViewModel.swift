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
}

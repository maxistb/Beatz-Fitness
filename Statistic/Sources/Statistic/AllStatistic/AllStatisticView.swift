//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

struct AllStatisticView: View {
  @FetchRequest(
    entity: Training.entity(),
    sortDescriptors: [],
    predicate: NSPredicate(
      format: "date >= %@",
      Calendar.current.date(byAdding: .day, value: -1, to: .now)! as CVarArg
    )
  )
  var trainings: FetchedResults<Training>

  @ObservedObject private var viewModel = AllStatisticViewModel()

  var body: some View {
    List {
      datePickerSection
      durationSection
      inTrainingSection
    }
    .navigationTitle("Gesamtstatistik")
  }

  var datePickerSection: some View {
    Section {
      DatePicker("Startdatum", selection: $viewModel.beginDate, displayedComponents: .date)
      DatePicker("Enddatum", selection: $viewModel.endDate, displayedComponents: .date)
        .onChange(of: viewModel.beginDate) { _ in
          viewModel.updatePredicate(trainings: trainings)
        }
        .onChange(of: viewModel.endDate) { _ in
          viewModel.updatePredicate(trainings: trainings)
        }
    }
  }

  var durationSection: some View {
    Section("Dauer & Häufigkeit") {
      Text("Gesamtdauer: " + viewModel.calculateAllTrainingDuration(for: trainings))
      Text("Trainingseinheiten: " + viewModel.calculateNumberTrainings(for: trainings))
    }
  }

  var inTrainingSection: some View {
    Section("Im Training") {
      Text("Gesamtgewicht: " + viewModel.calculateAllWeight(for: trainings))
      Text("Gesamtwiederholungen: " + viewModel.calculateAllReps(for: trainings))
      Text("Gesamtsätze: " + viewModel.calculateAllSets(for: trainings))
      Text("Strecke gelaufen: " + viewModel.calculateDistance(for: trainings))
      Text("kcal verbrannt: " + viewModel.calculateCalories(for: trainings))
    }
  }
}

//
// Created by Maximillian Stabe on 19.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

struct AllStatisticView: View {
  @FetchRequest(
    entity: Training.entity(),
    sortDescriptors: []
  )
  var trainings: FetchedResults<Training>

  @State private var beginDate: Date = .now
  @State private var endDate: Date = .now

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
      DatePicker("Startdatum", selection: $beginDate, displayedComponents: .date)
      DatePicker("Enddatum", selection: $endDate, displayedComponents: .date)
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
      Text("Gesamtgewicht: ")
      Text("Gesamtwiederholungen: ")
      Text("Gesamtsätze: ")
      Text("Strecke gelaufen: ")
      Text("kcal verbrannt: ")
    }
  }
}

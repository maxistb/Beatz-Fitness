//
// Created by Maximillian Stabe on 18.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Charts
import CoreData
import SwiftUI

struct GeneralStatisticChart: View {
  @FetchRequest(
    entity: Training.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Training.date, ascending: true)],
    predicate: NSPredicate(
      format: "date >= %@",
      Calendar.current.date(byAdding: .month, value: -3, to: Date())! as CVarArg
    )
  )
  var trainings: FetchedResults<Training>
  let generalItem: GeneralStatisticItems

  @ObservedObject private var viewModel = GeneralStatisticViewModel()

  var body: some View {
    VStack {
      picker
      chart
    }
    .navigationTitle(self.generalItem.name)
  }

  var picker: some View {
    Picker("", selection: $viewModel.currentSelection) {
      Text("3 Monate").tag(Selection.threeMonths)
      Text("6 Monate").tag(Selection.sixMonths)
      Text("1 Jahr").tag(Selection.oneYear)
      Text("Alle").tag(Selection.all)
    }
    .pickerStyle(.segmented)
    .padding()
    .onChange(of: viewModel.currentSelection) { _ in
      viewModel.updatePredicate(trainings: trainings)
    }
  }

  var chart: some View {
    Chart(trainings, id: \.self) { training in
      LineMark(
        x: .value("Datum", training.date),
        y: .value("Dauer", getValueForCase(training: training))
      )
      .lineStyle(StrokeStyle(lineWidth: 0.5))
    }
    .chartXAxisLabel(generalItem.xAxisLabel)
    .chartYAxisLabel(generalItem.yAxisLabel)
    .padding()
  }

  private func getValueForCase(training: Training) -> Double {
    switch generalItem {
    case .trainingduration:
      training.durationMinutes
    case .volume:
      viewModel.calculateVolume(for: training)
    case .setsPerExercise:
      viewModel.calculateSetsPerTraining(for: training)
    case .repsPerTraining:
      viewModel.calculateRepsPerTraining(for: training)
    case .bodyWeight:
      Double(training.bodyWeight) ?? 0
    }
  }
}

extension GeneralStatisticChart {
  enum Selection {
    case threeMonths
    case sixMonths
    case oneYear
    case all

    var number: Int {
      switch self {
      case .threeMonths:
        -3
      case .sixMonths:
        -6
      case .oneYear:
        -12
      case .all:
        0
      }
    }
  }
}

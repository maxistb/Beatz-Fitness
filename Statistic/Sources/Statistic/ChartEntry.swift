//
// Created by Maximillian Stabe on 18.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Charts
import CoreData
import SwiftUI

struct ChartEntry: View {
  @State private var currentSelection: Selection = .threeMonths
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

  init(generalItem: GeneralStatisticItems) {
    self.generalItem = generalItem

    let predicate = NSPredicate(
      format: "date >= %@",
      Calendar.current.date(byAdding: .month, value: currentSelection.number, to: Date())! as CVarArg
    )

    self._trainings = FetchRequest(
      entity: Training.entity(),
      sortDescriptors: [NSSortDescriptor(keyPath: \Training.date, ascending: true)],
      predicate: currentSelection == .all ? nil : predicate
    )
  }

  var body: some View {
    VStack {
      picker
      chart
    }
    .navigationTitle(self.generalItem.name)
  }

  var picker: some View {
    Picker("", selection: $currentSelection) {
      Text("3 Monate").tag(Selection.threeMonths)
      Text("6 Monate").tag(Selection.sixMonths)
      Text("1 Jahr").tag(Selection.oneYear)
      Text("Alle").tag(Selection.all)
    }
    .pickerStyle(.segmented)
    .padding()
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
      training.duration
    case .volume:
      GeneralStatisticCalc.shared.calculateVolume(for: training)
    case .setsPerExercise:
      GeneralStatisticCalc.shared.calculateSetsPerTraining(for: training)
    case .repsPerTraining:
      GeneralStatisticCalc.shared.calculateRepsPerTraining(for: training)
    case .bodyWeight:
      Double(training.bodyWeight) ?? 0
    }
  }
}

extension ChartEntry {
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

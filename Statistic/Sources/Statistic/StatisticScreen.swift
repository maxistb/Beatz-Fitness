//
// Created by Maximillian Stabe on 18.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import SwiftUI

public struct StatisticScreen: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Split.order,
        ascending: true)
    ])
  var splits: FetchedResults<Split>

  public init() {}

  public var body: some View {
    NavigationStack {
      List {
        generalSection
        allStatisticSection
        splitSection
        explanationSection
      }
      .navigationTitle("Statistiken")
    }
  }

  private var generalSection: some View {
    Section("Allgemein") {
      ForEach(GeneralStatisticItems.allCases, id: \.name) { navItem in
        NavigationLink(navItem.name) {
          ChartEntry(generalItem: navItem)
        }
      }
    }
  }

  private var allStatisticSection: some View {
    Section("Gesamtstatistik") {
      NavigationLink {} label: {
        Text("Gesamtstatistik")
      }
    }
  }

  private var splitSection: some View {
    Section("Splits") {
      ForEach(splits, id: \.self) { split in
        NavigationLink {
          StatisticDetailView(split: split)
        } label: {
          Text(split.name)
        }
      }
    }
  }

  private var explanationSection: some View {
    Section("Erklärungen") {
      NavigationLink {} label: {
        Text("Informationen")
      }
    }
  }
}

enum GeneralStatisticItems {
  case trainingduration
  case volume
  case setsPerExercise
  case repsPerTraining
  case bodyWeight

  static var allCases: [GeneralStatisticItems] {
    [.trainingduration, .volume, .setsPerExercise, .repsPerTraining, .bodyWeight]
  }

  var name: String {
    switch self {
    case .trainingduration:
      "Trainingsdauer"
    case .volume:
      "Volumen"
    case .setsPerExercise:
      "Sätze pro Training"
    case .repsPerTraining:
      "Wiederholungen pro Training"
    case .bodyWeight:
      "Körpergewicht"
    }
  }

  var yAxisLabel: String {
    switch self {
    case .trainingduration:
      "Minuten"
    case .volume:
      "Volumen"
    case .setsPerExercise:
      "Sätze/ Training"
    case .repsPerTraining:
      "Wdh./ Training"
    case .bodyWeight:
      "kg"
    }
  }

  var xAxisLabel: String {
    "Datum"
  }
}

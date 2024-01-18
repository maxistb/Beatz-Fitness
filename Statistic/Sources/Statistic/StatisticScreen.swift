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
      ForEach(GeneralNavigationItems.allCases, id: \.name) { navItem in
        NavigationLink(navItem.name) {
          navItem.destination
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

extension StatisticScreen {
  enum GeneralNavigationItems {
    case trainingduration
    case volume
    case setsPerExercise
    case repsPerTraining
    case bodyWeight

    static var allCases: [GeneralNavigationItems] {
      [.trainingduration, .volume, .setsPerExercise, .repsPerTraining, .bodyWeight]
    }

    var name: String {
      switch self {
      case .trainingduration:
        "Trainingsdauer"
      case .volume:
        "Volumen"
      case .setsPerExercise:
        "Sätze pro Übung"
      case .repsPerTraining:
        "Wiederholungen pro Training"
      case .bodyWeight:
        "Körpergewicht"
      }
    }

    var destination: AnyView {
      switch self {
      case .trainingduration:
        AnyView(ChartEntry(header: "Trainingsdauer", xAxisLabel: "Dauer", yAxisLabel: "Zeit"))
      case .volume:
        AnyView(RandomView())
      case .setsPerExercise:
        AnyView(RandomView())
      case .repsPerTraining:
        AnyView(RandomView())
      case .bodyWeight:
        AnyView(RandomView())
      }
    }
  }
}

//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import BeatzCoreData
import Styleguide
import SwiftUI
import UIComponents

public struct SplitScreen: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Split.order,
        ascending: true)
    ])
  var splits: FetchedResults<Split>
  @State private var showAddSplitSheet = false
  @StateObject var viewModel: SplitViewModel = .init()

  public init() {}

  public var body: some View {
    NavigationStack {
      Form {
        if !splits.isEmpty {
          ownSplitSection
        } else {
          Text("Füge bei dem \"+\" deinen ersten Split hinzu.")
        }
      }
      .navigationTitle(L10n.trainingsplansHeader)
      .toolbar { toolbarContent }
      .sheet(isPresented: $showAddSplitSheet) {
        AddSplitView(viewModel: viewModel)
          .presentationDragIndicator(.visible)
          .presentationDetents([.medium, .large])
      }
    }
  }

  private var ownSplitSection: some View {
    Section {
      ForEach(splits, id: \.self) { split in
        NavigationLink {
          ExercisesScreen(split: split)
        } label: {
          Text(split.name)
        }
        .modifier(SwipeActionWithAlert(
          buttonTitle: L10n.delete,
          confirmationDialog: L10n.deleteSplitConfirmationDialog,
          action: {
            viewModel.deleteSplit(splits: splits, indicesToDelete: IndexSet(integer: IndexSet.Element(split.order)))
          })
        )
      }
      .onMove { indices, newOffset in
        viewModel.moveSplit(splits: splits, oldIndices: indices, newIndex: newOffset)
      }
      .onDelete { indexSet in
        viewModel.deleteSplit(splits: splits, indicesToDelete: indexSet)
      }
    } header: {
      Text(L10n.ownSplits)
    }
  }

  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      EditButton()
    }

    ToolbarItem(placement: .topBarTrailing) {
      Button(action: {
        showAddSplitSheet = true
      }, label: {
        Image(systemName: "plus")
      })
    }
  }
}

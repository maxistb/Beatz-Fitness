//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct TrainingPlanScreen: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Split.order,
        ascending: true)
    ])
  var splits: FetchedResults<Split>
  @State private var showAddSplitSheet = false
  @StateObject var viewModel: SplitViewModel

  var body: some View {
    NavigationStack {
      Form {
        ownSplitSection
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
        .modifier(SwipeActionWithAlert(splits: splits, split: split, viewModel: viewModel))
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

private struct SwipeActionWithAlert: ViewModifier {
  @State private var showingAlert = false
  let splits: FetchedResults<Split>
  let split: Split
  let viewModel: SplitViewModel

  func body(content: Content) -> some View {
    content
      .swipeActions {
        Button(action: {
          showingAlert = true
        }, label: {
          Image(systemName: "trash")
        })
        .tint(.red)
      }
      .confirmationDialog(L10n.deleteSplitConfirmationDialog, isPresented: $showingAlert, titleVisibility: .visible) {
        Button(L10n.delete) {
          viewModel.deleteSplit(splits: splits, indicesToDelete: IndexSet(integer: IndexSet.Element(split.order)))
        }
      }
  }
}

struct SwipeActionModifier: ViewModifier {
  let action: ()

  func body(content: Content) -> some View {
    content
      .swipeActions {
        Button(action: {
          action
        }, label: {
          Image(systemName: "trash")
        })
        .tint(.red)
      }
  }
}

#Preview {
  TrainingPlanScreen(viewModel: SplitViewModel())
}

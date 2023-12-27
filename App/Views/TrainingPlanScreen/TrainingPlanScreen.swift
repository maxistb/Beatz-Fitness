//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct TrainingPlanScreen: View {
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(
      keyPath: \Split.order,
      ascending: true)])
  var splits: FetchedResults<Split>
  @State private var showAddSplitSheet = false
  @StateObject var viewModel: SplitViewModel

  var body: some View {
    NavigationStack {
      Form {
        ownSplitSection
        recommendedSection
      }
      .navigationTitle(L10n.trainingsplansHeader)
      .toolbar {
        toolbarContent
      }
      .sheet(isPresented: $showAddSplitSheet, content: {
        AddSplitView()
          .presentationDragIndicator(.visible)
          .presentationDetents(
            [.medium, .large]
          )
      })
    }
  }

  private var ownSplitSection: some View {
    Section {
      ForEach(splits, id: \.self) { split in
        NavigationLink {
          SplitDetailScreen()
        } label: {
          Text(split.name)
        }
      }
    } header: {
      Text("Eigene Splits")
    }
  }

  private var recommendedSection: some View {
    Section {
      NavigationLink("Push", destination: SplitDetailScreen())
    } header: {
      Text("Empfohlene Trainingspläne")
    }
  }

  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button(action: {}, label: {
        Text("Bearbeiten")
      })
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

#Preview {
  TrainingPlanScreen(viewModel: SplitViewModel())
}

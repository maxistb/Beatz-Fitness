//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct TrainerView: View {
  @ObservedObject private var viewModel = TrainerViewModel()

  var body: some View {
    List {
      ForEach(viewModel.trainer?.trainers ?? [], id: \.self) { trainer in
        createTrainerCell(trainer: trainer)
      }
    }
    .navigationTitle("Unsere Trainer 💪🏼")
    .task {
      do {
        viewModel.trainer = try await viewModel.getTrainers()
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  private func createTrainerCell(trainer: Trainer) -> some View {
    HStack {
      Text("").padding(.leading, -20)

      LazyImage(url: URL(string: trainer.imageURL)) { state in
        state.image?.resizable()
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .frame(width: 75, height: 75)
      }
      Spacer()
      VStack {
        Text(trainer.trainerName)
          .font(.headline)
        Text(trainer.trainerTaskDescription)
          .foregroundStyle(.gray)
          .font(.subheadline)
      }
      Spacer()
    }
    .padding(.vertical, 10)
  }
}

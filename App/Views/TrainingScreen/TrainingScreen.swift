//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI
import UIComponents

struct TrainingScreen: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject private var timerViewModel = TimerViewModel()
  @ObservedObject private var trainingViewModel: TrainingViewModel

  let split: Split

  init(split: Split) {
    self.split = split
    self.trainingViewModel = TrainingViewModel(split: split)

    trainingViewModel.initializeTrainingSets(split: split)
  }

  var body: some View {
    List {
      Section {
        TextField("Notizen", text: $trainingViewModel.notes)
        TextField("Körpergewicht", text: $trainingViewModel.bodyWeight)
          .keyboardType(.decimalPad)
      }

      ForEach(trainingViewModel.copyExerciseArray, id: \.self) { exercise in
        Section {
          HStack {
            Text(exercise.name)
              .font(.headline)
            Spacer()
            Image(systemName: "square.and.pencil")
              .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
              .onTapGesture { trainingViewModel.showExerciseBottomSheet = true }
          }

          ForEach(exercise.exerciseTrainingSetArray, id: \.self) { trainingSet in
            createExerciseCell(currentSet: trainingSet)
          }
          .onDelete { indexSet in
            trainingViewModel.deleteSet(exercise: exercise, indexSet: indexSet)
          }

          Button {
            trainingViewModel.addTrainingSet(exercise: exercise)
          } label: {
            Text("Hinzufügen")
              .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          }
        }
        .sheet(isPresented: $trainingViewModel.showExerciseBottomSheet) {
          TrainingBottomSheetView(split: split, exercise: exercise)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
      }

      Section {
        Text("Übung hinzufügen")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }

      Section {
        HStack {
          Spacer()
          SaveButton(title: "Training abschließen") {
            trainingViewModel.alertCase = .saveTraining(dismiss, trainingViewModel)
            trainingViewModel.showAlert = true
            trainingViewModel.saveTraining(split: split)
          }
          Spacer()
        }
      }
      .listRowBackground(Color.clear)
    }
    .navigationTitle(split.name)
    .navigationBarBackButtonHidden()
    .toolbar { createToolbar() }
    .alert(isPresented: $trainingViewModel.showAlert) { trainingViewModel.alertCase.createAlert }
    .sheet(isPresented: $trainingViewModel.showSwapExerciseSheet) { SwapExerciseView(split: split) }
    .sheet(isPresented: $trainingViewModel.showTimer) { TimerView(model: timerViewModel) }
    .onChange(of: trainingViewModel.forceViewUpdate) { _ in }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button {
        trainingViewModel.showAlert = true
        trainingViewModel.alertCase = .exitTraining(dismiss)
      }
      label: {
        Image(systemName: "rectangle.portrait.and.arrow.right")
      }
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Text(timerViewModel.secondsToCompletion.asTimestamp)
        .foregroundStyle(.primary)
        .font(.headline)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(action: {
        trainingViewModel.showTimer = true
      }, label: {
        Image(systemName: "timer")
      })
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Menu("\(Image(systemName: "ellipsis.circle"))", content: {
        Button(action: {
          trainingViewModel.showSwapExerciseSheet = true
        }, label: {
          HStack {
            Text("Übungen verschieben")
            Spacer()
            Image(systemName: "rectangle.2.swap")
          }
        })

        #warning("TODO: Implement func to save as Trainingplan")
        Button(action: {
          trainingViewModel.alertCase = .saveAsTrainingplan
          trainingViewModel.showAlert = true
        }, label: {
          HStack {
            Text("Als Trainingsplan speichern")
            Spacer()
            Image(systemName: "square.and.arrow.down")
          }
        })
      })
    }
  }

  private func createExerciseCell(currentSet: TrainingSet) -> some View {
    HStack {
      Image(systemName: "\(currentSet.order + 1).circle")
      VStack(alignment: .leading) {
        Text("Gewicht")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.weight ?? "" },
          set: { newValue in currentSet.weight = newValue }))
      }
      .keyboardType(.decimalPad)
      VStack(alignment: .leading) {
        Text("Wdh.")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.reps ?? "" },
          set: { newValue in currentSet.reps = newValue }))
          .keyboardType(.decimalPad)
      }
      VStack(alignment: .leading) {
        Text("Notizen")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.notes },
          set: { newValue in currentSet.notes = newValue }))
      }
      .padding(.leading, -20)

      Spacer()
      Image(systemName: "ellipsis")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
  }
}

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
  let training: Training?
  private let isTrainingView: Bool

  init(split: Split, training: Training? = nil) {
    self.split = split
    self.trainingViewModel = TrainingViewModel(split: split)
    self.training = training
    self.isTrainingView = training != nil
    trainingViewModel.initializeTrainingSets(split: split)
  }

  var body: some View {
    List {
      // Top-Bereich mit Datum, Dauer, Notizen und Körpergewicht
      createTop()

      // Übungen und zugehörige Sets
      if let training = training {
        createExercisesContent(training.exerciseArray)
      } else {
        createExercisesContent(trainingViewModel.copyExerciseArray)
      }

      // Abschnitt für das Hinzufügen einer Übung
      Section {
        Text("Übung hinzufügen")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }

      // Abschnitt für den Abschluss des Trainings mit dem "Training abschließen"-Button
      Section {
        HStack {
          Spacer()
          SaveButton(title: "Training abschließen") {
            trainingViewModel.alertCase = .saveTraining(dismiss, trainingViewModel, split)
            trainingViewModel.showAlert = true
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
}

extension TrainingScreen {
  private func createTop() -> some View {
    Section {
      if let training = training {
        Text(training.date.formatted())
        Text(training.duration)
      }
      TextField("Notizen", text: $trainingViewModel.notes)
      TextField("Körpergewicht", text: $trainingViewModel.bodyWeight)
        .keyboardType(.decimalPad)
    }
  }

  private func createExercisesContent(_ exercises: [Exercise]) -> some View {
    ForEach(exercises, id: \.self) { exercise in
      Section {
        createExerciseHeader(exercise: exercise)

        ForEach(exercise.exerciseTrainingSetArray, id: \.self) { trainingSet in
          createExerciseCell(currentSet: trainingSet)
        }
        .onDelete { indexSet in
          trainingViewModel.deleteSet(exercise: exercise, indexSet: indexSet)
        }

        createAddSetButton(exercise: exercise)
      }
      .sheet(isPresented: $trainingViewModel.showExerciseBottomSheet) {
        TrainingBottomSheetView(split: split, exercise: exercise)
          .presentationDetents([.medium])
          .presentationDragIndicator(.visible)
      }
    }
  }
}

// MARK: - UIComponent Functions

extension TrainingScreen {
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
          get: { currentSet.weight ?? "Error" },
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

  private func createAddSetButton(exercise: Exercise) -> some View {
    Button {
      trainingViewModel.addTrainingSet(exercise: exercise)
    } label: {
      Text("Hinzufügen")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
  }

  private func createExerciseHeader(exercise: Exercise) -> some View {
    HStack {
      Text(exercise.name)
        .font(.headline)
      Spacer()
      Image(systemName: "square.and.pencil")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
        .onTapGesture { trainingViewModel.showExerciseBottomSheet = true }
    }
  }
}

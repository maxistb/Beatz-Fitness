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
    self.isTrainingView = training == nil
    trainingViewModel.initializeTrainingSets(split: split)
  }

  var body: some View {
    List {
      createTopSection()

      if let training = training {
        createExercisesContent(training.exerciseArray)
      } else {
        createExercisesContent(trainingViewModel.copyExerciseArray)
      }

      if isTrainingView {
        createAddExerciseSection()
        createSaveTrainingSection()
      }
    }
    .navigationTitle(split.name)
    .navigationBarBackButtonHidden(isTrainingView)
    .toolbar { createToolbar() }
    .alert(isPresented: $trainingViewModel.showAlert) { trainingViewModel.alertCase.createAlert }
    .sheet(isPresented: $trainingViewModel.showSwapExerciseSheet) { SwapExerciseView(split: split) }
    .sheet(isPresented: $trainingViewModel.showTimer) { TimerView(model: timerViewModel) }
    .onChange(of: trainingViewModel.forceViewUpdate) { _ in }
  }
}

extension TrainingScreen {
  private func createTopSection() -> some View {
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

  private func createAddExerciseSection() -> some View {
    Section {
      Text("Übung Hinzufügen")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
  }

  private func createSaveTrainingSection() -> some View {
    Section {
      HStack {
        Spacer()
        SaveButton(title: "Training Abschließen") {
          trainingViewModel.alertCase = .saveTraining(dismiss, trainingViewModel, split)
          trainingViewModel.showAlert = true
        }
        Spacer()
      }
      .listRowBackground(Color.clear)
    }
  }
}

// MARK: - UI Component Functions

extension TrainingScreen {
  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    if isTrainingView {
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
        Menu("\(Image(systemName: "ellipsis.circle"))") {
          Button(action: {
            trainingViewModel.showSwapExerciseSheet = true
          }) {
            HStack {
              Text("Übung Verschieben")
              Spacer()
              Image(systemName: "rectangle.2.swap")
            }
          }

          #warning("TODO: Implement func to save as Trainingplan")
          Button(action: {
            trainingViewModel.alertCase = .saveAsTrainingplan
            trainingViewModel.showAlert = true
          }) {
            HStack {
              Text("Als Trainingsplan Speichern")
              Spacer()
              Image(systemName: "square.and.arrow.down")
            }
          }
        }
      }
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
          .onSubmit { try? CoreDataStack.shared.mainContext.save() }
      }
      .keyboardType(.decimalPad)
      VStack(alignment: .leading) {
        Text("Wdh.")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.reps ?? "" },
          set: { newValue in currentSet.reps = newValue }))
          .keyboardType(.decimalPad)
          .onSubmit { try? CoreDataStack.shared.mainContext.save() }
      }
      VStack(alignment: .leading) {
        Text("Notizen")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.notes },
          set: { newValue in currentSet.notes = newValue }))
          .onSubmit { try? CoreDataStack.shared.mainContext.save() }
      }
      .padding(.leading, -20)

      if isTrainingView {
        Spacer()
        Image(systemName: "ellipsis")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
    }
  }

  private func createAddSetButton(exercise: Exercise) -> some View {
    Button {
      trainingViewModel.addTrainingSet(exercise: exercise)
    } label: {
      Text("Satz Hinzufügen")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
  }

  private func createExerciseHeader(exercise: Exercise) -> some View {
    HStack {
      Text(exercise.name)
        .font(.headline)
      Spacer()
      if isTrainingView {
        Image(systemName: "square.and.pencil")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          .onTapGesture { trainingViewModel.showExerciseBottomSheet = true }
      }
    }
  }
}

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

  let training: Training?
  private let isTrainingView: Bool
  @State private var currentClickedExercise: Exercise?
  private var navBarTitle: String {
    training?.name ?? trainingViewModel.split.name
  }

  init(split: Split, training: Training? = nil) {
    self.trainingViewModel = TrainingViewModel(split: split)
    self.training = training
    self.isTrainingView = training == nil
    self.currentClickedExercise = trainingViewModel.copyExerciseArray.first

    trainingViewModel.initializeTrainingSets()
  }

  var body: some View {
    List {
      createTopSection()
      if let training = training {
        createExercisesContent(exercises: training.exerciseArray)
      } else {
        createExercisesContent(exercises: trainingViewModel.copyExerciseArray)
      }
      trainingBottomSections()
    }
    .navigationTitle(navBarTitle)
    .navigationBarBackButtonHidden(isTrainingView)
    .toolbar { createToolbar() }
    .alert(isPresented: $trainingViewModel.showAlert) { trainingViewModel.alertCase.createAlert }
    .sheet(isPresented: $trainingViewModel.showSwapExerciseSheet) {
      SwapExerciseView(exercises: trainingViewModel.copyExercises)
    }
    .sheet(isPresented: $trainingViewModel.showTimer) { TimerView(model: timerViewModel) }
    .sheet(isPresented: $trainingViewModel.showAddExerciseSheet) {
      BeatzExercisesView(
        appearance: .addTrainingExercises($trainingViewModel.copyExercises),
        showCurrentView: $trainingViewModel.showAddExerciseSheet)
    }
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

  private func createExercisesContent(exercises: [Exercise]) -> some View {
    ForEach(exercises, id: \.self) { exercise in
      Section {
        header(for: exercise)

        ForEach(exercise.exerciseTrainingSetArray, id: \.self) { trainingSet in
          let cellType = trainingViewModel.getExerciseCategoryForString(exerciseCategory: exercise.category)

          cellType.createExerciseCell(currentSet: trainingSet, isTrainingView: isTrainingView)
        }
        .onDelete { indexSet in
          trainingViewModel.deleteSet(exercise: exercise, indexSet: indexSet)
        }

        addSetButton(for: exercise)
      }
    }
    .sheet(isPresented: $trainingViewModel.showExerciseBottomSheet) {
      TrainingBottomSheetView(
        split: trainingViewModel.split,
        exercise: currentClickedExercise,
        exercises: $trainingViewModel.copyExercises
      )
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }

  private func trainingBottomSections() -> some View {
    Group {
      if isTrainingView {
        addExerciseText()
        saveTrainingButton()
      }
    }
  }

  private func addExerciseText() -> some View {
    Section {
      Button("Übung Hinzufügen") {
        trainingViewModel.showAddExerciseSheet = true
      }
    }
  }

  private func saveTrainingButton() -> some View {
    Section {
      HStack {
        Spacer()
        SaveButton(title: "Training Abschließen") {
          trainingViewModel.alertCase = .saveTraining(dismiss, trainingViewModel, trainingViewModel.split)
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
      leadingToolbarItems()
      trailingToolbarItems()
      setEllipsisMenu()
    }
  }

  private func leadingToolbarItems() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button {
        trainingViewModel.showAlert = true
        trainingViewModel.alertCase = .exitTraining(dismiss)
      } label: {
        Image(systemName: "rectangle.portrait.and.arrow.right")
      }
    }
  }

  @ToolbarContentBuilder
  private func trailingToolbarItems() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Text(timerViewModel.secondsToCompletion.asTimestamp)
        .foregroundStyle(.primary)
        .font(.headline)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        trainingViewModel.showTimer = true
      } label: {
        Image(systemName: "timer")
      }
    }
  }

  private func setEllipsisMenu() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Menu("\(Image(systemName: "ellipsis.circle"))") {
        swapExercisesMenuItem()
        saveAsTrainingPlanMenuItem()
      }
    }
  }

  private func swapExercisesMenuItem() -> some View {
    Button {
      trainingViewModel.showSwapExerciseSheet = true
    } label: {
      HStack {
        Text("Übung Verschieben")
        Spacer()
        Image(systemName: "rectangle.2.swap")
      }
    }
  }

  private func saveAsTrainingPlanMenuItem() -> some View {
    Button {
      trainingViewModel.alertCase = .saveAsTrainingplan(trainingViewModel)
      trainingViewModel.showAlert = true
    } label: {
      HStack {
        Text("Als Trainingsplan Speichern")
        Spacer()
        Image(systemName: "square.and.arrow.down")
      }
    }
  }

  private func addSetButton(for exercise: Exercise) -> some View {
    Button {
      trainingViewModel.addTrainingSet(exercise: exercise)
    } label: {
      Text("Satz Hinzufügen")
        .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
    }
  }

  private func header(for exercise: Exercise) -> some View {
    HStack {
      Text(exercise.name)
        .font(.headline)
      Spacer()
      if isTrainingView {
        Image(systemName: "square.and.pencil")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          .onTapGesture {
            currentClickedExercise = exercise
            trainingViewModel.showExerciseBottomSheet = true
          }
      }
    }
  }
}

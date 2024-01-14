//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

enum BeatzExerciseAppearance {
  case addExercises(Split)
  case addTrainingExercises(Binding<Set<Exercise>>)
  case replaceExercise(Binding<Set<Exercise>>, Exercise)

  var navigationTitle: String {
    switch self {
    case .addExercises, .addTrainingExercises:
      "Übungen Hinzufügen"
    case .replaceExercise:
      "Übung Ersetzen"
    }
  }
}

struct BeatzExercisesView: View {
  @ObservedObject private var viewModel = MachinesViewModel()
  @State private var appearance: BeatzExerciseAppearance
  @Binding var showCurrentView: Bool

  init(appearance: BeatzExerciseAppearance, showCurrentView: Binding<Bool>) {
    self._appearance = State(initialValue: appearance)
    self._showCurrentView = showCurrentView
  }

  var body: some View {
    NavigationStack {
      List(MachineMuscleGroup.allCases, id: \.hashValue) { muscleGroup in
        if let machines = viewModel.machines?.machines {
          NavigationLink(
            muscleGroup.getName(),
            destination: SelectBeatzExercisesView(
              showCurrentView: $showCurrentView,
              machines: machines.filter { $0.muscleGroup == muscleGroup },
              header: muscleGroup.getName(),
              appearance: appearance
            )
          )
        }
      }
      .navigationTitle(appearance.navigationTitle)
      .toolbar { createToolbar() }
      .task { viewModel.machines = try? await viewModel.getMachines() }
    }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      switch appearance {
      case .addExercises(let split):
        NavigationLink("Eigene Übung") {
          AddEditExerciseView(appearance: .addExercise(split), showCurrentView: $showCurrentView)
        }
      case .addTrainingExercises(let exercises):
        NavigationLink("Eigene Übung") {
          AddEditExerciseView(appearance: .addTrainingExercise(exercises), showCurrentView: $showCurrentView)
        }
      case .replaceExercise(let binding, let exercise):
        NavigationLink("Eigene Übung") {
          AddEditExerciseView(appearance: .replaceExercise(binding, exercise), showCurrentView: $showCurrentView)
        }
      }
    }
  }
}

private struct SelectBeatzExercisesView: View {
  @State private var selectedMachines: Set<Machine> = []
  @Binding var showCurrentView: Bool

  let machines: [Machine]
  let header: String
  let appearance: BeatzExerciseAppearance

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(machines, id: \.hashValue) { machine in
          ExerciseRow(
            selectedMachines: $selectedMachines,
            showCurrentView: $showCurrentView,
            appearance: appearance,
            machine: machine
          )
        }
      }
    }
    .navigationTitle(header)
    .toolbar { createToolbar() }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    switch appearance {
    case .addExercises(let split):
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          addExercisesToSplit(split: split)
          showCurrentView = false
        }
        label: { Text("Hinzufügen") }
      }
    case .replaceExercise, .addTrainingExercises:
      ToolbarItem {}
    }
  }

  private func addExercisesToSplit(split: Split) {
    for machine in selectedMachines {
      ExercisesViewModel.shared
        .createExerciseForSplit(
          name: machine.displayName,
          category: machine.category.rawValue,
          countSets: 3,
          notes: "",
          split: split
        )
    }
  }
}

private struct ExerciseRow: View {
  @State private var isSelected: Bool = false
  @Binding var selectedMachines: Set<Machine>
  @Binding var showCurrentView: Bool
  let appearance: BeatzExerciseAppearance
  let machine: Machine

  var body: some View {
    HStack {
      imageView
      machineNameView
      Spacer()
      trailingIcon
    }
    .padding(.top, 5)
    .contentShape(Rectangle())
    .onTapGesture {
      switch appearance {
      case .addExercises:
        selectMachine()
      case .replaceExercise(let exercises, let exercise):
        replaceExercise(exercises: exercises, exercise: exercise)
        showCurrentView = false
      case .addTrainingExercises(let exercises):
        addExercises(exercises: exercises)
        showCurrentView = false
      }
    }
  }

  private var trailingIcon: AnyView {
    switch appearance {
    case .addExercises:
      AnyView(Toggle("", isOn: $isSelected)
        .toggleStyle(BoxToggleStyle()))
    case .replaceExercise, .addTrainingExercises:
      AnyView(Image(systemName: "chevron.right")
        .foregroundStyle(.gray))
    }
  }

  @MainActor
  private var imageView: some View {
    LazyImage(url: URL(string: machine.imageURL)) { state in
      if let image = state.image {
        image
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .frame(width: 100, height: 100)
      }
    }
  }

  private var machineNameView: some View {
    VStack(alignment: .leading) {
      Text(machine.displayName)
        .font(.headline)
      Text(machine.description)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }

  private func selectMachine() {
    isSelected.toggle()
    if isSelected {
      selectedMachines.insert(machine)
    } else {
      selectedMachines.remove(machine)
    }
  }

  private func replaceExercise(exercises: Binding<Set<Exercise>>, exercise: Exercise) {
    let newExercise = Exercise.createTrainingExercise(
      name: machine.displayName,
      category: machine.category.rawValue,
      countSets: Int(exercise.countSets),
      notes: "",
      order: Int(exercise.order)
    )
    exercises.wrappedValue.remove(exercise)
    exercises.wrappedValue.insert(newExercise)

    for order in 0 ..< newExercise.countSets {
      _ = TrainingSet.createTrainingSet(exercise: newExercise, order: Int(order))
    }

    try? CoreDataStack.shared.mainContext.save()
  }

  private func addExercises(exercises: Binding<Set<Exercise>>) {
    let newExercise = Exercise.createTrainingExercise(
      name: machine.displayName,
      category: machine.category.rawValue,
      countSets: 3,
      notes: "",
      order: exercises.wrappedValue.count
    )
    exercises.wrappedValue.insert(newExercise)

    for order in 0 ..< newExercise.countSets {
      _ = TrainingSet.createTrainingSet(exercise: newExercise, order: Int(order))
    }

    try? CoreDataStack.shared.mainContext.save()
  }
}

private struct BoxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle()
    }, label: {
      VStack {
        configuration.label
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
      }
    })
  }
}

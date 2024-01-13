//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

enum BeatzExerciseAppearance {
  case addExercises(Split)
  case replaceExercise(Binding<Set<Exercise>>, Exercise)

  var navigationTitle: String {
    switch self {
    case .addExercises(let split):
      "Übungen Hinzufügen"
    case .replaceExercise(let binding, let exercise):
      "Übung Ersetzen"
    }
  }
}

struct BeatzExercisesView: View {
  @ObservedObject private var viewModel = MachinesViewModel()
  @State private var appearance: BeatzExerciseAppearance

  init(appearance: BeatzExerciseAppearance) {
    _appearance = State(initialValue: appearance)
  }

  var body: some View {
    NavigationStack {
      List(MachineMuscleGroup.allCases, id: \.hashValue) { muscleGroup in
        if let machines = viewModel.machines?.machines {
          NavigationLink(
            muscleGroup.getName(),
            destination: SelectBeatzExercisesView(
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
        NavigationLink("Eigene Übung", destination: AddEditExerciseView(appearance: .addExercise(split)))
      case .replaceExercise(let binding, let exercise):
        NavigationLink("Eigene Übung", destination: AddEditExerciseView(appearance: .replaceExercise(binding, exercise)))
      }
    }
  }
}

private struct SelectBeatzExercisesView: View {
  @Environment(\.dismiss) var dismiss
  @State private var selectedMachines: Set<Machine> = []
  let machines: [Machine]
  let header: String
  let appearance: BeatzExerciseAppearance

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(machines, id: \.hashValue) { machine in
          ExerciseRow(
            selectedMachines: $selectedMachines,
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
          dismiss()
        }
        label: { Text("Hinzufügen") }
      }
    case .replaceExercise(let binding, let exercise):
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
  @Environment(\.dismiss) private var dismiss
  @State private var isSelected: Bool = false
  @Binding var selectedMachines: Set<Machine>
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
      case .addExercises(let split):
        selectMachine()
      case .replaceExercise(let exercises, let exercise):
        replaceExercise(exercises: exercises, exercise: exercise)
      }
    }
  }

  private var trailingIcon: AnyView {
    switch appearance {
    case .addExercises(let split):
      AnyView(Toggle("", isOn: $isSelected)
        .toggleStyle(BoxToggleStyle()))
    case .replaceExercise(let binding, let exercise):
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
    dismiss()
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

//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct BeatzExercisesView: View {
  @ObservedObject private var viewModel = MachinesViewModel()
  let split: Split
  let action: (() -> Void)?
  private let isSelectMachinesView: Bool

  init(split: Split, action: (() -> Void)? = nil) {
    self.split = split
    self.action = action
    if self.action != nil {
      self.isSelectMachinesView = false
    } else {
      self.isSelectMachinesView = true
    }
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
              split: split,
              isSelectMachinesView: isSelectMachinesView, action: action))
        }
      }
      .navigationTitle(isSelectMachinesView ? "Übungen" : "Übung ersetzen")
      .toolbar { createToolbar() }
      .task { viewModel.machines = try? await viewModel.getMachines() }
    }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      NavigationLink("Eigene Übung", destination: AddEditUebungView(split: split))
    }
  }
}

private struct SelectBeatzExercisesView: View {
  @Environment(\.dismiss) var dismiss
  @State private var selectedMachines: Set<Machine> = []
  let machines: [Machine]
  let header: String
  let split: Split
  let isSelectMachinesView: Bool
  let action: (() -> Void)?

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(machines, id: \.hashValue) { machine in
          ExerciseRow(
            selectedMachines: $selectedMachines,
            machine: machine,
            isSelectMachinesView: isSelectMachinesView,
            action: action)
        }
      }
    }
    .navigationTitle(header)
    .toolbar { createToolbar() }
  }

  private func addExercisesToSplit() {
    for machine in selectedMachines {
      ExercisesViewModel.shared
        .createUebungForSplit(
          name: machine.displayName,
          category: machine.category.rawValue,
          countSets: 3,
          notes: "",
          split: split)
    }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    if isSelectMachinesView {
      ToolbarItem(placement: .topBarTrailing) {
        Button { addExercisesToSplit(); dismiss() }
          label: { Text("Hinzufügen") }
      }
    }
  }
}

private struct ExerciseRow: View {
  @Environment(\.dismiss) private var dismiss

  @State private var isSelected: Bool = false
  @Binding var selectedMachines: Set<Machine>

  let machine: Machine
  let isSelectMachinesView: Bool
  let action: (() -> Void)?

  var body: some View {
    HStack {
      imageView
      machineNameView
      Spacer()
      trailingIcon
    }
    .padding(.top, 5)
    .contentShape(Rectangle())
    .onTapGesture { (action ?? selectMachine)() }
  }

  private var trailingIcon: AnyView {
    if isSelectMachinesView {
      AnyView(Toggle("", isOn: $isSelected)
        .toggleStyle(BoxToggleStyle()))
    } else {
      AnyView(Image(systemName: "chevron.right").foregroundStyle(.gray))
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

//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct BeatzExercisesView: View {
  let split: Split
  let action: (() -> Void)?
  private let isSelectMachinesView: Bool

  init(split: Split, action: (() -> Void)? = nil) {
    self.split = split
    self.action = action
    if let action = self.action {
      self.isSelectMachinesView = false
    } else {
      self.isSelectMachinesView = true
    }
  }

  var body: some View {
    NavigationStack {
      List(getMachinesAndMuscleGroups(), id: \.1) { machines, muscleGroup in
        NavigationLink(
          muscleGroup,
          destination: SelectBeatzExercisesView(
            machines: machines,
            header: muscleGroup,
            split: split,
            isSelectMachinesView: isSelectMachinesView, action: action))
      }
      .navigationTitle(isSelectMachinesView ? "Übung ersetzen" : "Übungen")
      .toolbar { createToolbar() }
    }
  }

  private func getMachinesAndMuscleGroups() -> [([Machines], String)] {
    return [
      ([.abduktormaschine, .adduktormaschine, .beinpressmaschine, .beinpressePlateloaded, .beinstreckerNeu,
        .kickbackmaschine, .wadenmaschine], "Beine"),
      ([.bankdrueckmaschine, .brustpresse, .butterfly], "Brust"),
      ([.dipmaschine], "Trizeps"),
      ([.highrow, .klimmzugmaschine, .latzugBasic, .latzugmaschine, .rudern, .tBar], "Rücken")
    ]
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
  @State private var selectedMachines: Set<Machines> = []
  let machines: [Machines]
  let header: String
  let split: Split
  let isSelectMachinesView: Bool
  let action: (() -> Void)?

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(machines, id: \.rawValue) { machine in
          ExerciseRow(selectedMachines: $selectedMachines, machine: machine, isSelectMachinesView: isSelectMachinesView, action: action)
        }
      }
    }
    .navigationTitle(header)
    .toolbar { createToolbar() }
  }

  private func addExercisesToSplit() {
    for machine in selectedMachines {
      ExercisesViewModel.shared
        .createUebungForSplit(name: machine.getMachineName(), category: machine.getMachineCategory(), countSets: 3, notes: "", split: split)
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
  @Binding var selectedMachines: Set<Machines>

  let machine: Machines
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
    LazyImage(url: URL(string: machine.getURLForCase())) { state in
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
      Text(machine.getMachineName())
        .font(.headline)
      Text(machine.getMachineCategory())
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }

  private func selectMachine() {
    isSelected.toggle()
    if isSelected { selectedMachines.insert(machine) }
    else { selectedMachines.remove(machine) }
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

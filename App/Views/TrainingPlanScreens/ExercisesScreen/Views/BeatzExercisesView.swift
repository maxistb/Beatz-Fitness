//
// Created by Maximillian Stabe on 30.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct BeatzExercisesView: View {
  let split: Split
  let viewModel: ExercisesViewModel

  var body: some View {
    NavigationStack {
      List(getMachinesAndMuscleGroups(), id: \.1) { machines, muscleGroup in
        NavigationLink(muscleGroup, destination: SelectBeatzExercisesView(machines: machines, header: muscleGroup, split: split, viewModel: viewModel))
      }
      .navigationTitle("Übungen")
    }
  }

  private func getMachinesAndMuscleGroups() -> [([Machines], String)] {
    return [
      ([.abduktormaschine, .adduktormaschine, .beinpressmaschine, .beinpressePlateloaded, .beinstreckerNeu, .kickbackmaschine, .wadenmaschine], "Beine"),
      ([.bankdrueckmaschine, .brustpresse, .butterfly], "Brust"),
      ([.dipmaschine], "Trizeps"),
      ([.highrow, .klimmzugmaschine, .latzugBasic, .latzugmaschine, .rudern, .tBar], "Rücken")
    ]
  }
}

private struct SelectBeatzExercisesView: View {
  @Environment(\.dismiss) var dismiss
  @State private var selectedMachines: Set<Machines> = []
  let machines: [Machines]
  let header: String
  let split: Split
  let viewModel: ExercisesViewModel

  var body: some View {
    List {
      Section("Übungen") {
        ForEach(machines, id: \.rawValue) { machine in
          ExerciseRow(selectedMachines: $selectedMachines, machine: machine)
        }
      }
    }
    .navigationTitle(header)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { addExercisesToSplit(); dismiss() }
          label: { Text("Hinzufügen") }
      }
    }
  }

  private func addExercisesToSplit() {
    for machine in selectedMachines {
      viewModel.createUebungForSplit(name: machine.getMachineName(), category: machine.getMachineCategory(), countSets: 3, notes: "", split: split)
    }
  }
}

private struct ExerciseRow: View {
  @State private var isSelected = false
  @Binding var selectedMachines: Set<Machines>
  let machine: Machines

  var body: some View {
    HStack {
      LazyImage(url: URL(string: machine.getURLForCase())) { state in
        state.image?.resizable()
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .frame(width: 100, height: 100)
      }

      VStack(alignment: .leading) {
        Text(machine.getMachineName())
          .font(.headline)
        Text(machine.getMachineCategory())
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()

      Toggle("", isOn: $isSelected)
        .toggleStyle(BoxToggleStyle())
    }
    .padding(.top, 5)
    .onChange(of: isSelected) { _ in
      if isSelected {
        selectedMachines.insert(machine)
      } else {
        selectedMachines.remove(machine)
      }
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

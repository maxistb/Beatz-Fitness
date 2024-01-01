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

  @State private var trainingNotes = ""
  @State private var bodyWeight = ""
  @State private var showExitAlert = false
  @State private var showSwapExerciseSheet = false
  @State private var showExerciseBottomSheet = false
  @State private var showTimer = false

  let split: Split

  var body: some View {
    List {
      Section {
        TextField("Notizen", text: $trainingNotes)
        TextField("Körpergewicht", text: $bodyWeight)
          .keyboardType(.decimalPad)
      }

      ForEach(split.splitExercises.sorted { $0.order < $1.order }, id: \.self) { exercise in
        Section {
          HStack {
            Text(exercise.name)
              .font(.headline)
            Spacer()
            Image(systemName: "square.and.pencil")
              .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
              .onTapGesture { showExerciseBottomSheet = true }
          }
          ForEach(exercise.exerciseSets, id: \.self) { currentSet in
            createExerciseCell(currentSet: currentSet)
          }
          Text("Hinzufügen")
            .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
        }
        .sheet(isPresented: $showExerciseBottomSheet) {
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
          SaveButton(title: "Training abschließen") {}
          Spacer()
        }
      }
      .listRowBackground(Color.clear)
    }
    .navigationTitle(split.name)
    .navigationBarBackButtonHidden()
    .toolbar { createToolbar() }
    .alert(isPresented: $showExitAlert) {
      Alert(
        title: Text("Möchtest du das Training abbrechen?"),
        message: Text("Die Daten werden nicht gespeichert."),
        primaryButton: .cancel(Text("Abbrechen")),
        secondaryButton: .default(
          Text("OK"),
          action: { dismiss() }))
    }
    .sheet(isPresented: $showSwapExerciseSheet) { SwapExerciseView(split: split) }
    .sheet(isPresented: $showTimer) { TimerView(model: timerViewModel) }
  }

  @ToolbarContentBuilder
  private func createToolbar() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button { showExitAlert = true }
        label: { Image(systemName: "rectangle.portrait.and.arrow.right") }
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Text(timerViewModel.secondsToCompletion.asTimestamp)
        .foregroundStyle(.primary)
        .font(.headline)
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Button(action: { showTimer = true }, label: {
        Image(systemName: "timer")
      })
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Menu("\(Image(systemName: "ellipsis.circle"))", content: {
        Button(action: { showSwapExerciseSheet = true }, label: {
          HStack {
            Text("Übungen verschieben")
            Spacer()
            Image(systemName: "rectangle.2.swap")
          }
        })

        #warning("TODO: Implement func to save as Trainingplan")
        Button(action: {}, label: {
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
      Image(systemName: "\(1).circle")
      VStack(alignment: .leading) {
        Text("Gewicht")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.weight },
          set: { newValue in currentSet.weight = newValue }))
      }
      .keyboardType(.decimalPad)
      VStack(alignment: .leading) {
        Text("Wdh.")
          .foregroundStyle(.gray).font(.system(size: 14))
        TextField("", text: Binding(
          get: { currentSet.reps },
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

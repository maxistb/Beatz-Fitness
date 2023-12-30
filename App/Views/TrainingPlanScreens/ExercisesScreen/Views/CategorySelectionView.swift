//
// Created by Maximillian Stabe on 29.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI
import UIComponents

struct CategorySelectionView: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var currentClickedCategory: ExerciseCategory = .weightlifting
  @Binding var exerciseCategory: String

  init(exerciseCategory: Binding<String>) {
    self._exerciseCategory = exerciseCategory
    self._currentClickedCategory = State(initialValue: getExerciseCategoryForString(exerciseCategory: exerciseCategory.wrappedValue))
  }

  var body: some View {
    List {
      ForEach(self.currentClickedCategory.getSectionsAndHeader(), id: \.0) { categories, header in
        Section(header) {
          ForEach(categories, id: \.hashValue) { category in
            self.createCell(category: category)
          }
        }
      }
    }
    .navigationTitle("Kategorie")
  }
}

extension CategorySelectionView {
  private func createCell(category: ExerciseCategory) -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(category.getHeader())
          .foregroundColor(self.colorScheme == .dark ? .white : .black)
        Text(category.getSubHeader())
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      if self.currentClickedCategory == category {
        Image(systemName: "checkmark")
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      self.currentClickedCategory = category
      self.$exerciseCategory.wrappedValue = category.rawValue
    }
  }

  private func getExerciseCategoryForString(exerciseCategory: String) -> ExerciseCategory {
    switch exerciseCategory {
    case "staticexercise":
      return .staticexercise
    case "bodyweight":
      return .bodyweight
    case "supported":
      return .supported
    case "repsonly":
      return .repsonly
    case "time":
      return .time
    case "cardio":
      return .cardio
    default:
      return .weightlifting
    }
  }
}

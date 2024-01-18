//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

struct CoursesView: View {
  @ObservedObject private var viewModel: CoursesViewModel = .init()
  @State private var selectedDayIndex = 0
  @State private var currentShownCourses: [Course]?

  enum Days: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday

    func getName() -> String {
      switch self {
      case .monday:
        "Mo"
      case .tuesday:
        "Di"
      case .wednesday:
        "Mi"
      case .thursday:
        "Do"
      case .friday:
        "Fr"
      }
    }
  }

  var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(getCourses(viewModel: viewModel), id: \.0) { day, courses in
            Button {
              selectedDayIndex = day.rawValue
              currentShownCourses = courses
            } label: {
              Text(day.getName())
                .font(.headline)
                .foregroundColor(selectedDayIndex == day.rawValue ? .white : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(selectedDayIndex == day.rawValue ? Asset.Color.beatzColor.swiftUIColor : Color.clear)
                .cornerRadius(20)
            }
          }
        }
      }
      if let courses = currentShownCourses {
        List(courses, id: \.self) { course in
          createCourseCell(course: course)
        }
        .gesture(
          DragGesture()
            .onEnded { value in
              withAnimation(.timingCurve(0.2, 0.2, 0.2, 0.2)) {
                if value.translation.width < 0, selectedDayIndex < 4 {
                  selectedDayIndex += 1
                } else if value.translation.width > 0, selectedDayIndex > 0 {
                  selectedDayIndex -= 1
                }
              }
            })
        .onChange(of: selectedDayIndex) { newIndex in
          if let newCourses = getCourses(viewModel: viewModel)[newIndex].1 { // gets the courses at specified index
            currentShownCourses = newCourses
          }
        }
      }
    }
    .navigationTitle("🗓️ Kursplan")
    .task {
      let courses = try? await viewModel.getCourses()
      viewModel.courses = courses
      currentShownCourses = courses?.courses.monday
    }
  }

  private func getCourses(viewModel: CoursesViewModel) -> [(Days, [Course]?)] {
    return [
      (.monday, viewModel.courses?.courses.monday),
      (.tuesday, viewModel.courses?.courses.tuesday),
      (.wednesday, viewModel.courses?.courses.wednesday),
      (.thursday, viewModel.courses?.courses.thursday),
      (.friday, viewModel.courses?.courses.friday)
    ]
  }

  private func createCourseCell(course: Course) -> some View {
    VStack(alignment: .leading) {
      Text("\(course.name) \(course.trainer)")
        .font(.headline)
      Text(course.time)
        .foregroundStyle(.gray)
        .font(.subheadline)
    }
  }
}
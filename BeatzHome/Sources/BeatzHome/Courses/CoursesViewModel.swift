//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

class CoursesViewModel: ObservableObject {
  @Published var courses: Courses?

  let url = Bundle.module.url(forResource: "Courses", withExtension: "json")!

  func getCourses() async throws -> Courses {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let courses = try JSONDecoder().decode(Courses.self, from: data)
      return courses
    } catch {
      print("DEBUG: Error fetching data - \(error.localizedDescription)")
      throw error
    }
  }
}

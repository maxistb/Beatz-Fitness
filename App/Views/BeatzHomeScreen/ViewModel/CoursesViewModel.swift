//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

class CoursesViewModel: ObservableObject {
  @Published var courses: Welcome?

  let url = Bundle.main.url(forResource: "Courses", withExtension: "json")!

  func getCourses() async throws -> Welcome {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let courses = try JSONDecoder().decode(Welcome.self, from: data)
      return courses
    } catch {
      print("DEBUG: Error fetching data - \(error.localizedDescription)")
      throw error
    }
  }
}

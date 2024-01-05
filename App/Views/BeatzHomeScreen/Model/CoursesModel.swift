//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

struct Courses: Codable {
  let courses: CoursesDay
}

struct CoursesDay: Codable {
  let monday: [Course]
  let tuesday: [Course]
  let wednesday: [Course]
  let thursday: [Course]
  let friday: [Course]

  enum CodingKeys: String, CodingKey {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
  }
}

struct Course: Codable, Hashable {
  let name: String
  let time: String
  let trainer: String
}

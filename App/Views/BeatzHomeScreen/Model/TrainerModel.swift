//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

struct Trainers: Codable {
  let trainers: [Trainer]

  enum CodingKeys: String, CodingKey {
    case trainers = "Trainers"
  }
}

struct Trainer: Codable, Hashable {
  let trainerName: String
  let trainerTaskDescription: String
  let imageURL: String
}

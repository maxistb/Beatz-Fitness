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

class TrainerViewModel: ObservableObject {
  @Published var trainer: Trainers?

  let url = Bundle.main.url(forResource: "Trainers", withExtension: "json")!

  func getTrainers() async throws -> Trainers {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let trainer = try JSONDecoder().decode(Trainers.self, from: data)
      return trainer
    } catch {
      print("DEBUG: Error fetching data - \(error.localizedDescription)")
      throw error
    }
  }
}

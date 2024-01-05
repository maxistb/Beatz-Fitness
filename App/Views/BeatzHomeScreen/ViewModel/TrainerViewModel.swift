//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

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

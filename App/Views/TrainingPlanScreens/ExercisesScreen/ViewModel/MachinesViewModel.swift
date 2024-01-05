//
// Created by Maximillian Stabe on 05.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

class MachinesViewModel: ObservableObject {
  @Published var machines: Machines?

  let url = Bundle.main.url(forResource: "Machines", withExtension: "json")!

  func getMachines() async throws -> Machines {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let machines = try JSONDecoder().decode(Machines.self, from: data)
      return machines
    } catch {
      print("DEBUG: Error fetching data - \(error.localizedDescription)")
      throw error
    }
  }
}

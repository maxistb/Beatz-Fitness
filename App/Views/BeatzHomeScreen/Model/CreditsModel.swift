//
// Created by Maximillian Stabe on 04.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

struct CreditPersons: Codable {
  let creditPersons: [CreditPerson]

  enum CodingKeys: String, CodingKey {
    case creditPersons = "CreditPersons"
  }
}

struct CreditPerson: Codable, Hashable {
  let personName: String
  let personTitle: String
  let websiteLink: String
  let buttonTitle: String
  let hasWebsite: Bool
  let infoText: String
  let imageString: String
}

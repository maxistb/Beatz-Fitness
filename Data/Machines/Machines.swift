//
// Created by Maximillian Stabe on 27.12.23.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

// swiftlint:disable line_length cyclomatic_complexity

import Foundation
import SwiftUI

enum Machines: String {
  case abduktormaschine
  case adduktormaschine
  case bankdrueckmaschine
  case beinpressePlateloaded
  case beinpressmaschine
  case beinstreckerNeu
  case brustpresse
  case butterfly
  case dipmaschine
  case highrow
  case kickbackmaschine
  case klimmzugmaschine
  case latzugBasic
  case latzugmaschine
  case reverseButterfly
  case rudern
  case seithebenmaschine
  case tBar
  case wadenmaschine

  static let allCases: [Machines] = [
    .abduktormaschine, .adduktormaschine,
    .bankdrueckmaschine, .beinpressePlateloaded, .beinpressmaschine, .beinstreckerNeu, .brustpresse, .butterfly,
    .dipmaschine,
    .highrow,
    .kickbackmaschine, .klimmzugmaschine,
    .latzugBasic, .latzugmaschine,
    .reverseButterfly, .rudern,
    .seithebenmaschine,
    .tBar,
    .wadenmaschine,
  ]

  func getURLForCase() -> String {
    switch self {
    case .abduktormaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTKliA8GEfNH8QiptEljbZfch4iO73e8X9IiHiqilX0r5iqIMKSj4k3gS2JxiRaO9eK0e_NXk7Heten0QNIIuuQAW0VNw=s1600"
    case .adduktormaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRPiU_jqOFz_JEG81dEjOLnx9OqDqzF74lad3IwWXzrrSMGFn6xlThVKPt3IzfIGe4Hvbg6yhXRaQVZA9pO5gRiH5iYcg=s1600"
    case .bankdrueckmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYR7i1rCBNaVSs-cSQeOgNEzyK7nC-tC3T32wq7q9y-AmZnMmOoCxHJRkyZy1fHzc7A62A0IvHFSiBlkW3n_HF2vHs-j=s1600"
    case .beinpressePlateloaded:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQdN3eDNp2a4BC6JwJ88McJ6RqMs_vzryFxpsklLaPEl-C6hRAgjfForAcKaXkINsFa-QuANSFXlq2C-eKF9FDODuiB=s1600"
    case .beinpressmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQj5VdQHwAO-6rr9iJDFqxYwmAfvaSmiemQruW2tNQ6ZOuY2LKj0Fi0kRLbGsDiBr2FFcF1KkNCAOU3aQCcU9_4U_q9wQ=s1600"
    case .beinstreckerNeu:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRUH0YR-ao151n4pWnbzATWGF6K9KacqvAVl3H2WjkkJK9MdTzPSy1wUBnbnkrBGqY63zcRkjdd10IonauEXB5CK64RdQ=s1600"
    case .brustpresse:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQG9ScTxLLdztvVVKdOljYHUC_DCh7wytUdrU0BNH1LyW0Vi1qGsEzvJuqKEcXpoUo_Khftr_CO49rD2616sI2UhvJaKQ=s1600"
    case .butterfly:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRBUnBDSKRIxx4LKAI8mGANx1hNvRtcxBh1raVHzRl4dCL_KPM_NH1n9h-az2h-onzlKZsE4C7Jk3H6pa6FFq3Lh8SP6A=s1600"
    case .dipmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTCh3gU_C7ttAwAyYCjRZ8Zz80t84NmkX7LDXOfAne0f-xuFSzaL59JaV5UIZ2RC24H_wZPjiXYcKovyhhzSleSmLYE_w=s1600"
    case .highrow:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYSs5oYo7m3hLLPaC19NvurtheV9c9BvHxAoexkxhvTtGr5SMcIDjIozYlsneY7NBKPaT-9Vy96TvzeBC1ePdh8pWl6IMA=s1600"
    case .kickbackmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYS93aa2_s2O1sPkJcjV--ToGGbLpnAIDyvThhrn9tlr1PE2JcoFNvorZDDm6HXOUyR5UqIAm175_t2VFJMXpxQAEXsBXA=s1600"
    case .klimmzugmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRKI0zKCrNYzZvpfEERIUSX4noAYlzdxviHG8WUpNc26D_kYZlqkAb5fNTpQOWu1uXOygt5ZTdLf4HicCAcxMLlR1dZ8A=s1600"
    case .latzugBasic:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTgZCNg2fvoGSxHwTUusQr7RyobPxN2_nLP60nOnQ2rBBLfugJAB4WCRFSBfCCxMuidIooP18LSX2zJht2wBtUnk7l4iw=s1600"
    case .latzugmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTZRqs1u5yI6OUIVrVJt7t6NNtNcq41A9jhMmWghSZSnqbDeJJBLeQodWvQ5LYl3ysGVK65FDwzA4D7fVa2oNligL-yjA=s1600"
    case .reverseButterfly:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRKh6BH_KUVRvUglk3QYhLr27EjWj21pMGPD3mHRTn2A19auTuXiRerYSrM9IrWwjV-EPZPUKJQBQ12K9t8MoVAnGqWRg=s1600"
    case .rudern:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQ7vkg2ykyooUf2qWgzf7kbSlTBJqhEqrW1CF1mVsHeBaBwzimTDg2v-958HI3DLXbWPCn7rzFtASwXHWkbk0cSdMH_hw=s1600"
    case .seithebenmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTbFFBXGNzFIT1DA7ZAtc49E3PFKIIbKuY652vcs-RW1kwjbuTHxfRVXroxHR4hC_-gF7znFbplx2w42wIUkOSLvVtGnQ=s1600"
    case .tBar:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYT7KoYIjCaW4unCFgBQFyjgjO6h3EiTJqtI5GOdzgvMpUhItX_lV2Zo9vc4tIoje_m4daeTU1h8V8poL-ypPWU1twhU7g=s1600"
    case .wadenmaschine:
      "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTWNab6oB6HJrVx3nwC-w-GWzQuQSr0WC1ZO7Ylphr9QbTHovHaxG2g-kYi9nAcHArcku32SwiHqqf6mzRBx41_53dz=s1600"
    }
  }

  func getMachineName() -> String {
    switch self {
    case .abduktormaschine:
      "Abduktormaschine"
    case .adduktormaschine:
      "Adduktormaschine"
    case .bankdrueckmaschine:
      "Bankdrückmaschine"
    case .beinpressePlateloaded:
      "Beinpresse"
    case .beinpressmaschine:
      "Beinpressmaschine"
    case .beinstreckerNeu:
      "Beinstrecker (Neu)"
    case .brustpresse:
      "Brustpresse"
    case .butterfly:
      "Butterfly"
    case .dipmaschine:
      "Dipmaschine"
    case .highrow:
      "Highrow"
    case .kickbackmaschine:
      "Kickbackmaschine"
    case .klimmzugmaschine:
      "Klimmzugmaschine"
    case .latzugBasic:
      "Latzug"
    case .latzugmaschine:
      "Latzugmaschine"
    case .reverseButterfly:
      "Reverse Butterfly"
    case .rudern:
      "Rudern"
    case .seithebenmaschine:
      "Seithebenmaschine"
    case .tBar:
      "T-Bar"
    case .wadenmaschine:
      "Wadenmaschine"
    }
  }

  func getMachineCategory() -> String {
    switch self {
    default:
      "weightlifting"
    }
  }
}

// swiftlint:enable line_length cyclomatic_complexity

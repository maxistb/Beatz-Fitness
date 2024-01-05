//
// Created by Maximillian Stabe on 04.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI
import NukeUI

public struct NavigationLinkWithImageAndText: View {
  private let imageURL: URL?
  private let text: String
  private let destination: AnyView

  public init(imageURLString: String, text: String, destination: AnyView) {
    self.imageURL = URL(string: imageURLString)
    self.text = text
    self.destination = destination
  }

  public var body: some View {
    NavigationLink(destination: destination) {
      HStack {
        Text("").padding(.leading, -20)
        LazyImage(url: imageURL) { state in
          if let image = state.image {
            image
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
              .cornerRadius(40)
          }
        }
        .padding(.leading, -10)
        Text(text)
      }
    }
  }
}

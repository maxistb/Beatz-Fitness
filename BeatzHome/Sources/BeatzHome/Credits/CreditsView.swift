//
// Created by Maximillian Stabe on 03.01.24.
// Copyright © 2023 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import Styleguide
import SwiftUI
import UIComponents

struct CreditsView: View {
  @ObservedObject private var viewModel = CreditPersonViewModel()

  var body: some View {
    List {
      Section("App-Development") {
        if let creditPersons = viewModel.creditPersons?.creditPersons {
          ForEach(creditPersons, id: \.self) { creditPerson in
            NavigationLinkWithImageAndText(
              imageURLString: creditPerson.imageString,
              text: creditPerson.personName,
              destination: AnyView(
                CreditsDetailView(creditPerson: creditPerson)
              )
            )
          }
        }
      }
    }
    .navigationTitle("Credits")
    .task { viewModel.creditPersons = try? await viewModel.getCreditPeople() }
  }
}

private struct CreditsDetailView: View {
  @Environment(\.colorScheme) var colorScheme
  let creditPerson: CreditPerson

  var body: some View {
    ScrollView {
      VStack {
        LazyImage(url: URL(string: creditPerson.imageString)!) { state in
          if let image = state.image {
            image
              .resizable()
              .scaledToFit()
              .frame(width: 200, height: 200)
          }
        }

        Text(creditPerson.personName)
          .font(.title)

        Text(creditPerson.personTitle)
          .font(.subheadline)
          .foregroundColor(.secondary)

        if creditPerson.hasWebsite {
          Button { UIApplication.shared.open(URL(string: creditPerson.websiteLink)!) }
            label: {
              Text(creditPerson.buttonTitle)
                .font(.headline)
                .foregroundColor(Asset.Color.beatzColor.swiftUIColor)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ?
                  Asset.Color.darkSecondary.swiftUIColor :
                  Asset.Color.lightSecondary.swiftUIColor)
                .cornerRadius(15.0)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }

        Text(creditPerson.infoText)
          .padding(.vertical, 10)
          .padding(.horizontal, 25)
          .multilineTextAlignment(.leading)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .padding(.horizontal)
              .foregroundColor(
                colorScheme == .dark ?
                  Asset.Color.darkSecondary.swiftUIColor :
                  Asset.Color.lightSecondary.swiftUIColor
              )
          )
      }
    }
  }
}

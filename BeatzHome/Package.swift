// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BeatzHome",
  defaultLocalization: "de",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "BeatzHome",
      targets: ["BeatzHome"]
    )
  ],
  dependencies: [
    .package(name: "UIComponents", path: "../Packages/UIComponents"),
    .package(url: "https://github.com/kean/Nuke.git", branch: "main")
  ],
  targets: [
    .target(
      name: "BeatzHome",
      dependencies: [
        .product(name: "UIComponents", package: "UIComponents"),
        .product(name: "Nuke", package: "Nuke")
      ],
      resources: [
        .process("Resources")
      ]
    )
  ]
)

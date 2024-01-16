// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UIComponents",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "UIComponents",
      targets: ["UIComponents"]
    )
  ],
  dependencies: [
    .package(name: "Styleguide", path: "../Packages/Styleguide")
  ],
  targets: [
    .target(
      name: "UIComponents",
      dependencies: [
        .product(name: "Styleguide", package: "Styleguide")
      ]
    )
  ]
)

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Diary",
  platforms: [.iOS(.v16)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Diary",
      targets: ["Diary"]
    )
  ],
  dependencies: [
    .package(name: "UIComponents", path: "../UIComponents"),
    .package(name: "Styleguide", path: "../Styleguide"),
    .package(name: "BeatzCoreData", path: "../BeatzCoreData"),
    .package(name: "Split", path: "../Split")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Diary",
      dependencies: [
        .product(name: "UIComponents", package: "UIComponents"),
        .product(name: "Styleguide", package: "Styleguide"),
        .product(name: "BeatzCoreData", package: "BeatzCoreData"),
        .product(name: "Split", package: "Split")
      ]
    )
  ]
)

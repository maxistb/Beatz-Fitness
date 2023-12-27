// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Styleguide",
  defaultLocalization: "de",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Styleguide",
      targets: ["Styleguide"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", .upToNextMajor(from: "6.6.2")),
    .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.0.0"))
  ],
  targets: [
    .target(
      name: "Styleguide",
      dependencies: [
        .product(name: "Lottie", package: "lottie-spm")
      ],
      resources: [
        .process("Resources")
      ],
      plugins: [
        .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
      ]
    )
  ]
)

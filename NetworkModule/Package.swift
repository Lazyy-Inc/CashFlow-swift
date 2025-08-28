// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetworkModule",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "NetworkModule", targets: ["NetworkModule"])
  ],
  dependencies: [
    .package(path: "../Models"),
    .package(path: "../Banners"),
    .package(url: "https://github.com/theosementa/NetworkKit", branch: "1.0.3")
  ],
  targets: [
    .target(
      name: "NetworkModule",
      dependencies: [
        "Models",
        "Banners",
        .product(name: "NetworkKit", package: "NetworkKit")
      ],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .testTarget(name: "NetworkModuleTests", dependencies: ["NetworkModule"])
  ]
)

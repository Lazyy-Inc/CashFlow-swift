// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PreferenceModule",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "PreferenceModule", targets: ["PreferenceModule"])
  ],
  dependencies: [
    .package(path: "../EventModule"),
    .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.8")
  ],
  targets: [
    .target(
      name: "PreferenceModule",
      dependencies: [
        .product(name: "EventModule", package: "EventModule"),
        .product(name: "StatsKit", package: "StatsKit")
      ],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .testTarget(name: "PreferenceModuleTests", dependencies: ["PreferenceModule"])
  ]
)

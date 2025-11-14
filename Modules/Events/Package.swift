// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Events",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "Events", targets: ["Events"])
  ],
  dependencies: [
    .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.9")
  ],
  targets: [
    .target(
      name: "Events",
      dependencies: [
        .product(name: "StatsKit", package: "StatsKit")
      ]
    )
  ]
)

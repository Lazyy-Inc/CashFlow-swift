// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Repositories",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "Repositories", targets: ["Repositories"])
  ],
  dependencies: [
      .package(path: "../Persistence"),
      .package(path: "../Models")
  ],
  targets: [
    .target(
      name: "Repositories",
      dependencies: [
        "Persistence",
        "Models"
      ]
    ),
    .testTarget(name: "RepositoriesTests", dependencies: ["Repositories"])
  ]
)

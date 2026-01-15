// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stores",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Stores", targets: ["Stores"])
    ],
    dependencies: [
      .package(path: "../Models"),
      .package(path: "../Networking"),
      .package(path: "../Preferences"),
      .package(path: "../Events"),
      .package(path: "../Repositories"),
      .package(path: "../Utilities"),
      
      .package(url: "https://github.com/theosementa/TheoKit", exact: "1.1.5"),
      .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3")
    ],
    targets: [
        .target(
            name: "Stores",
            dependencies: [
              "Models",
              "Networking",
              "Preferences",
              "Events",
              "Repositories",
              "Utilities",
              .product(name: "TheoKit", package: "TheoKit"),
              .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "StoresTests", dependencies: ["Stores"])
    ]
)

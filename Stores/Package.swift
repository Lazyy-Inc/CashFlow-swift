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
      .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "Stores",
            dependencies: [
              "Models"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "StoresTests", dependencies: ["Stores"]),
    ]
)

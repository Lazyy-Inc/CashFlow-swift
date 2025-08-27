// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mocks",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Mocks", targets: ["Mocks"])
    ],
    dependencies: [
      .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "Mocks",
            dependencies: [
              "Models"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "MocksTests", dependencies: ["Mocks"])
    ]
)

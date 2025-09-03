// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mocks",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Mocks", targets: ["Mocks"])
    ],
    dependencies: [
      .package(path: "../Models"),
      .package(url: "https://github.com/theosementa/TheoKit", exact: "1.1.5")
    ],
    targets: [
        .target(
            name: "Mocks",
            dependencies: [
              "Models",
              .product(name: "TheoKit", package: "TheoKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "MocksTests", dependencies: ["Mocks"])
    ]
)

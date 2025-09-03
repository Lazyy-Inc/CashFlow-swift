// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Preferences", targets: ["Preferences"])
    ],
    dependencies: [
      .package(path: "../Events"),
      .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.9")
    ],
    targets: [
        .target(
            name: "Preferences",
            dependencies: [
              .product(name: "Events", package: "Events"),
              .product(name: "StatsKit", package: "StatsKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "PreferencesTests", dependencies: ["Preferences"])
    ]
)

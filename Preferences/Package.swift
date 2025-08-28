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
      .package(path: "../Events")
    ],
    targets: [
        .target(
            name: "Preferences",
            dependencies: [
              .product(name: "Events", package: "Events")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "PreferencesTests", dependencies: ["Preferences"])
    ]
)

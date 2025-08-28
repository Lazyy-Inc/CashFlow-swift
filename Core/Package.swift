// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(path: "../Preferences"),
        .package(path: "../EventModule"),
        .package(url: "https://github.com/theosementa/TheoKit", exact: "1.0.7"),
        .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.8"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Preferences",
                "EventModule",
                .product(name: "TheoKit", package: "TheoKit"),
                .product(name: "StatsKit", package: "StatsKit"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)

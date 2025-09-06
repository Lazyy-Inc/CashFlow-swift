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
        .package(path: "../Events"),
        .package(path: "../Stores"),
        .package(path: "../Models"),
        
        .package(url: "https://github.com/theosementa/TheoKit", exact: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3"),
        .package(url: "https://github.com/theosementa/AlertKit", branch: "main"),
        .package(url: "https://github.com/theosementa/NotificationKit", branch: "1.0.5")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Preferences",
                "Events",
                "Stores",
                "Models",
                .product(name: "TheoKit", package: "TheoKit"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AlertKit", package: "AlertKit"),
                .product(name: "NotificationKit", package: "NotificationKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)

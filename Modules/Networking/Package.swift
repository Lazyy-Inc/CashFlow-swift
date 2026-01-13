// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Networking", targets: ["Networking"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Banners"),
        .package(url: "https://github.com/theosementa/NetworkKit", branch: "1.0.4"),
        .package(url: "https://github.com/theosementa/TheoKit", branch: "1.1.5")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                "Models",
                "Banners",
                .product(name: "NetworkKit", package: "NetworkKit"),
                .product(name: "TheoKit", package: "TheoKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)

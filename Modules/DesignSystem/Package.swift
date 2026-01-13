// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

var resources: [Resource] {
    if isPreview {
        return [
            .process("./Resources/Assets/Colors.xcassets"),
            .process("./Resources/Assets/Icons.xcassets")
        ]
    } else {
        return []
    }
}

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Mocks"),
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../Banners"),
        .package(path: "../Navigation"),
        
        .package(url: "https://github.com/theosementa/TheoKit", branch: "1.1.5"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI", branch: "1.0.0")
    ],
    targets: [
        .target(
          name: "DesignSystem",
          dependencies: [
              "Core",
              "Models",
              "Mocks",
              "Stores",
              "Banners",
              "Navigation",
              .product(name: "TheoKit", package: "TheoKit"),
              .product(name: "ConfettiSwiftUI", package: "ConfettiSwiftUI")
          ],
          resources: resources,
          swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)

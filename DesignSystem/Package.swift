// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

var resources: [Resource] {
    if isPreview {
        return [
            .process("Resources/PreviewAssets.xcassets")
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
        .package(path: "../Banners")
    ],
    targets: [
        .target(
          name: "DesignSystem",
          dependencies: [
              "Core",
              "Models",
              "Mocks",
              "Stores",
              "Banners"
          ],
          swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "DesignSystemTests", dependencies: ["DesignSystem"])
    ]
)

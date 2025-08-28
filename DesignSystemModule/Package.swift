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
    name: "DesignSystemModule",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystemModule", targets: ["DesignSystemModule"])
    ],
    dependencies: [
        .package(path: "../CoreModule"),
        .package(path: "../Mocks"),
        .package(path: "../Models"),
        .package(path: "../Stores")
    ],
    targets: [
        .target(
            name: "DesignSystemModule",
            dependencies: [
                "CoreModule",
                "Models",
                "Mocks",
                "Stores"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "DesignSystemModuleTests",
            dependencies: ["DesignSystemModule"]
        )
    ]
)

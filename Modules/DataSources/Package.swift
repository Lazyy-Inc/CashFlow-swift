// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataSources",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DataSources",
            targets: ["DataSources"]
        )
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Stores")
    ],
    targets: [
        .target(
            name: "DataSources",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Stores", package: "Stores")
            ]
        ),
        .testTarget(
            name: "DataSourcesTests",
            dependencies: ["DataSources"]
        )
    ]
)

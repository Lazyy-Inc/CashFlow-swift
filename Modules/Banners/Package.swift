// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Banners",
  platforms: [.iOS(.v17)],
  products: [
    .library(name: "Banners", targets: ["Banners"])
  ],
  dependencies: [
    .package(url: "https://github.com/theosementa/TheoKit", exact: "1.1.5")
  ],
  targets: [
    .target(
      name: "Banners",
      dependencies: [
        .product(name: "TheoKit", package: "TheoKit")
      ]
    ),
    .testTarget(name: "BannersTests", dependencies: ["Banners"])
  ]
)

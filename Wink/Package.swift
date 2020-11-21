// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wink",
    platforms: [
      .iOS(.v13)
    ],
    products: [
        .library(
            name: "Wink",
            targets: ["Wink"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Wink",
            dependencies: [])
    ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Snap",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Snap",
            targets: ["Snap"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Snap",
            dependencies: []),
        .testTarget(
            name: "SnapTests",
            dependencies: ["Snap"]),
    ]
)

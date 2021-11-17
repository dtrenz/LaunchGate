// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LaunchGate",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "LaunchGate",
            targets: ["LaunchGate"]),
    ],
    targets: [
        .target(
            name: "LaunchGate",
            dependencies: [],
            path: "Source"),
    ]
)

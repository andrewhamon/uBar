// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "uBar",
    platforms: [.macOS(.v11)],
    targets: [
        .executableTarget(name: "uBar"),
        .testTarget(name: "uBarTests", dependencies: ["uBar"]),
    ]
)

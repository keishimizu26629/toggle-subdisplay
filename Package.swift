// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "toggle-subdisplay",
    platforms: [
        .macOS(.v10_15)
    ],
    targets: [
        .executableTarget(
            name: "toggle-subdisplay",
            path: "Sources/toggle-subdisplay"),
    ]
)

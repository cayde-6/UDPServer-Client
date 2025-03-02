// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UDPClient",
    platforms: [
        .macOS(.v10_15),
    ],
    targets: [
        .executableTarget(name: "UDPClient"),
    ]
)

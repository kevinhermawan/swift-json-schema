// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONSchema",
    products: [
        .library(
            name: "JSONSchema",
            targets: ["JSONSchema"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        .target(
            name: "JSONSchema",
            dependencies: []),
        .testTarget(
            name: "JSONSchemaTests",
            dependencies: ["JSONSchema"]
        )
    ]
)

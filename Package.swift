// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xccov2lcov",
    products: [
        .executable(name: "xccov2lcov", targets: ["xccov2lcov"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "XCCovLib",
            dependencies: []
        ),
        .executableTarget(
            name: "xccov2lcov",
            dependencies: [
                .target(name: "XCCovLib"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "xccov2lcovTests",
            dependencies: ["xccov2lcov"]
        ),
    ]
)

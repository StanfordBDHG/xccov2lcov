// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// Originally created by David Whetstone @ Trax Retail, 10/16/19.


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
            name: "XCCovLibTests",
            dependencies: ["XCCovLib"]
        )
    ]
)

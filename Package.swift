// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "v0.0.0"
let checksum = "8fb1b0cc0a88bd3767b8a8d9aa2f30bd5d6e61c14b1b7e3cd3d0e08d8cb5540d"

let package = Package(
    name: "AliceOnboarding",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "AliceOnboarding",
            targets: ["AliceOnboarding"]),
    ],
    dependencies: [
            .package(
                name: "OpenSSL",
                url: "https://github.com/krzyzanowskim/OpenSSL.git",
                .exact("1.1.2000")
            )
    ],
    targets: [
        .binaryTarget(name: "AliceOnboarding", 
                      url: "https://storage.googleapis.com/releases/ios/AliceOnboarding-\(version).zip",
                      checksum: \(checksum)),
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "0.0.0"
let checksum = ""

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

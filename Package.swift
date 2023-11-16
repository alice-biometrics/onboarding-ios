// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.0.0"
let checksum = "0044d682534fd0227e8953ee3b009236c1b72b392bc2c532facd2a79253779ee"

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
                      url: "https://storage.googleapis.com/alicebiometrics.com/releases/ios/AliceOnboarding-\(version).zip",
                      checksum: "\(checksum)"),
    ]
)

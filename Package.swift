// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.4.2"
let checksum = "d76bde85700471fe21e66adedcdf161f854f53b289dc037c73f61ab768f55d9c"

let package = Package(
    name: "AliceOnboarding",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AliceOnboarding",
            targets: ["AliceOnboardingBundle"]),
    ],
    targets: [
        .target(
            name: "AliceOnboardingBundle",
            dependencies: ["AliceOnboarding"]
        ),
        .binaryTarget(
            name: "AliceOnboarding",
            url: "https://storage.googleapis.com/alicebiometrics.com/releases/ios/AliceOnboarding-\(version).zip",
            checksum: "\(checksum)"
        ),
    ]
)


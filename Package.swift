// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.3.5"
let checksum = "60a3618dcca998e061e7e606f9441c0ca2b5a2bdb46a35a47af79ba8c104dab4"

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


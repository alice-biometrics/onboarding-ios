// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.3.2"
let checksum = "1054917f23bd9758971ab8a971947cfd1fffe2b0bf6c18e5373811193e781df6"

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
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3")
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


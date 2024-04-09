// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.2.9"
let checksum = "e892fa9653569b3d2bfc049ab648eea76799b0b5150427b6dd8ff06bd9c1d960"

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
        .target(name: "AliceOnboardingBundle",
            dependencies: [
                "AliceOnboarding",
              ]
           ),
        .binaryTarget(name: "AliceOnboarding", 
                      url: "https://storage.googleapis.com/alicebiometrics.com/releases/ios/AliceOnboarding-\(version).zip",
                      checksum: "\(checksum)"),
    ]
)

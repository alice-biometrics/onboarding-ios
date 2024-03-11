// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.2.7"
let checksum = "1c3d836c4f11470128d260bd3da05bdbc4c8ac8bf70bd8307271aef616b4b5af"

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

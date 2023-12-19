// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "2.0.1"
let checksum = "5cc164e64b3b49c17adb8d74d765edd9c526a0419d03366449af6ba36d313e39"

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
            .package(
                name: "OpenSSL",
                url: "https://github.com/krzyzanowskim/OpenSSL.git",
                .exact("1.1.2000")
            )
    ],
    targets: [
      .target(name: "AliceOnboardingBundle",
            dependencies: [
                "AliceOnboarding",
                .product(name: "OpenSSL", package: "OpenSSL")
              ]
           ),
        .binaryTarget(name: "AliceOnboarding", 
                      url: "https://storage.googleapis.com/alicebiometrics.com/releases/ios/AliceOnboarding-\(version).zip",
                      checksum: "\(checksum)"),
    ]
)

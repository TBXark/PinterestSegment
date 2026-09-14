// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PinterestSegment",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "PinterestSegment", targets: ["PinterestSegment"]),
    ],
    targets: [
        .target(
            name: "PinterestSegment",
            path: "Sources/PinterestSegment"
        ),
        .testTarget(
            name: "PinterestSegmentTests",
            dependencies: ["PinterestSegment"],
            path: "Tests/PinterestSegmentTests"
        ),
    ],
    swiftLanguageModes: [.v5]
)

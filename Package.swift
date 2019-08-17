// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "KakaJSON",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "KakaJSON",
                 targets: ["KakaJSON"])
    ],
    targets: [
        .target(
            name: "KakaJSON",
            path: "KakaJSON"
        )
    ]
)

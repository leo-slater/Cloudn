// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "CloudnKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "CloudnKit", targets: ["CloudnKit"])
    ],
    targets: [
        .target(name: "CloudnKit", resources: [.process("Resources")]),
        .testTarget(name: "CloudnKitTests", dependencies: ["CloudnKit"])
    ]
)

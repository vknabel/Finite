// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Finite",
    products: [
        .library(
            name: "Finite",
            targets: ["Finite"]
        ),
    ],
    targets: [
        .target(name: "Finite", path: "Sources"),
        .testTarget(name: "FiniteTests", dependencies: ["Finite"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v3, .v4, .v4_2]
)

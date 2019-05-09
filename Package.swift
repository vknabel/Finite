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
    dependencies: [
        .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.4"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.40.8"), // dev
        .package(url: "https://github.com/f-meloni/Rocket.git", from: "0.9.1"), // dev
    ],
    targets: [
        .target(name: "Finite", path: "Sources"),
        .testTarget(name: "FiniteTests", dependencies: ["Finite"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v3, .v4, .v4_2]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test --generate-linuxmain",
                "swift test",
                "swift run swiftformat Sources *.swift Tests",
                "jazzy || true",
                "git add .",
            ],
        ],
        "rocket": ["steps": [
            ["script": ["content": "echo Release $VERSION"]],
            "hide_dev_dependencies",
            ["git_add": ["paths": ["Package.swift"]]],
            ["commit": ["no_verify": true]],
            "tag",
            "unhide_dev_dependencies",
            ["commit": ["no_verify": true, "message": "Unhide dev dependencies"]],
            "push",
        ]],
    ]).write()
#endif

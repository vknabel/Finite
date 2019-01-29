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
        .package(url: "https://github.com/orta/Komondor.git", from: "1.0.0"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint.git", from: "0.28.1"), // dev
        .package(url: "https://github.com/f-meloni/Rocket", from: "0.5.0"), // dev
    ],
    targets: [
        .target(name: "Finite", path: "Sources"),
        .testTarget(name: "FiniteTests", dependencies: ["Finite"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v3, .v4, .v4_2]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test --generate-linuxmain",
                "swift test",
                "swift run swiftformat . || true",
                "swift run swiftlint autocorrect --path Sources/",
                "swift run swiftlint autocorrect --path Tests/",
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
    ])
#endif

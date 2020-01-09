// swift-tools-version:5.0
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
//        .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.4"), // dev
//        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.43.5"), // dev
//        .package(url: "https://github.com/f-meloni/Rocket.git", from: "1.0.0"), // dev
    ],
    targets: [
        .target(name: "Finite", path: "Sources"),
        .testTarget(name: "FiniteTests", dependencies: ["Finite"], path: "Tests"),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift package generate-xcodeproj --enable-code-coverage || true",
                "swift test --generate-linuxmain || true",
                "swift test",
                "swift run swiftformat Sources *.swift Tests",
                "git add .",
            ],
        ],
        "rocket": ["steps": [
            "jazzy --head \"$(cat Scripts/docs-head.html)\" --module-version $VERSION || true",
            ["script": ["content": "echo Release $VERSION"]],
            "hide_dev_dependencies",
            ["git_add": ["paths": ["Package.swift", "docs"]]],
            ["commit": ["no_verify": true]],
            "tag",
            "unhide_dev_dependencies",
            "push",
            ["commit": ["no_verify": true, "message": "Unhide dev dependencies"]],
            "push",
        ]],
    ]).write()
#endif
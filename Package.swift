// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "WidgetNote",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "WidgetNote",
            path: ".",
            exclude: ["README.md"],
            sources: ["App", "Core", "Widgets", "UI", "Controls", "Models", "Services", "Settings"]
        )
    ]
)

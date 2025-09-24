// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FolderUploader",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "FolderUploader",
            targets: ["FolderUploader"]
        )
    ],
    targets: [
        .executableTarget(
            name: "FolderUploader",
            dependencies: []
        )
    ]
)
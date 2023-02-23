// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "SmoltyTabView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SmoltyTabView",
            targets: ["SmoltyTabView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "SmoltyTabView",
            dependencies: [
                .product(name: "Introspect", package: "SwiftUI-Introspect")
            ]
        )
    ]
)
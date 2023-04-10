// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxUtils",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "RxUtils",
            targets: ["RxUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "12.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "RxUtils",
            dependencies: [
                "RxSwift",
                "RxSwiftExt",
                .product(name: "APExtensionsOccupiable", package: "APExtensions"),
                .product(name: "APExtensionsOptionalType", package: "APExtensions"),
                .product(name: "RoutableLogger", package: "RoutableLogger"),
            ],
            path: "RxUtils/Classes",
            exclude: [],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ]
)

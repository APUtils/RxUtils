// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxUtils",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .macOS(.v10_11),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "RxUtils",
            targets: ["RxUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", .upToNextMajor(from: "6.0.0")),
        // TODO: Doesn't work yet
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "10.1.6"))
    ],
    targets: [
        .target(
            name: "RxUtils",
            dependencies: ["RxSwift", "RxSwiftExt", "APExtensions"],
            path: "RxUtils/Classes",
            exclude: []),
    ]
)

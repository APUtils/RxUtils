// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxUtils",
    platforms: [
        .iOS(.v12),
//        .macOS(.v10_13),
//        .tvOS(.v12),
//        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "RxUtils",
            targets: ["RxUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "RxUtils",
            dependencies: [
                "RxGesture",
                "RxSwiftExt",
                .product(name: "APExtensionsDispatch", package: "APExtensions"),
                .product(name: "APExtensionsOccupiable", package: "APExtensions"),
                .product(name: "APExtensionsOptionalType", package: "APExtensions"),
                .product(name: "RoutableLogger", package: "RoutableLogger"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "RxUtils",
            exclude: [],
            sources: ["Classes"],
            resources: [
                .process("Privacy/RxUtils/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ]
)

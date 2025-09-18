// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "doordeck_headless_sdk_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "doordeck-headless-sdk-flutter", targets: ["doordeck_headless_sdk_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/doordeck/doordeck-ios-sdk-beta.git", branch: "main")
    ],
    targets: [
        .target(
            name: "doordeck_headless_sdk_flutter",
            dependencies: [
                .product(name: "DoordeckCoreSDK", package: "doordeck-ios-sdk-beta")
            ]
        ),
        .target(
            name: "doordeck_headless_sdk_flutter_ui",
            dependencies: [
                 .product(name: "DoordeckCoreSDK_UI", package: "doordeck-ios-sdk-beta")
            ]
        )
    ]
)

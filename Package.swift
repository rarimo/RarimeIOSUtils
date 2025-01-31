// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "RarimeIOSUtils",
    platforms: [.macOS(.v12), .iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RarimeIOSUtils",
            targets: ["RarimeIOSUtils"]
        ),
        .executable(
            name: "RarimeIOSUtilsClient",
            targets: ["RarimeIOSUtilsClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "RarimeIOSUtilsMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "RarimeIOSUtils", dependencies: ["RarimeIOSUtilsMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "RarimeIOSUtilsClient", dependencies: ["RarimeIOSUtils"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "RarimeIOSUtilsTests",
            dependencies: [
                "RarimeIOSUtilsMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

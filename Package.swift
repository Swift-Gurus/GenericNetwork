// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GenericNetwork",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GenericNetwork",
            targets: ["GenericNetwork"])
    ],
    dependencies: [
       .package(url: "https://github.com/Swift-Gurus/XCTestToolKit.git", branch: "main"),
       .package(url: "https://github.com/Swift-Gurus/FunctionalSwift", branch: "master"),
       .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 5, 0))
    ],
    targets: [
        .target(
            name: "GenericNetwork",
            dependencies: [ .product(name: "FunctionalSwift", package: "FunctionalSwift")],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "GenericNetworkTests",
            dependencies: ["GenericNetwork",
                           .product(name: "XCTestToolKit", package: "XCTestToolKit"),
                           .product(name: "FunctionalSwift", package: "FunctionalSwift")]),
    ]
)

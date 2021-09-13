// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AMG88",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AMG88",
            targets: ["AMG88"]),
        .executable(name: "amg88-test", targets: [
            "amg88-test"
        ])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AMG88",
            dependencies: [
                "SwiftyGPIO"
            ]),
        .testTarget(
            name: "AMG88Tests",
            dependencies: ["AMG88"]),
        .target(
            name: "amg88-test",
            dependencies: [
                "SwiftyGPIO",
                "AMG88"
            ]),
    ]
)

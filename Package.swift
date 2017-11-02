// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TopBuongiornissimoBot",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "TopBuongiornissimoBot", targets: ["TopBuongiornissimoBot"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/cipi1965/telegram-bot-swift.git", from: "0.17.2"),
        .package(url: "https://github.com/OpenKitten/Meow.git", from: "1.0.0"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", from: "1.1.0"),
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TopBuongiornissimoBot",
            dependencies: [
                "TelegramBotSDK",
                "Meow",
                "Commander",
                "SwiftDotEnv",
                "Vapor",
            ]),
        .testTarget(
            name: "TopBuongiornissimoBotTests",
            dependencies: ["TopBuongiornissimoBot"]),
    ]
)

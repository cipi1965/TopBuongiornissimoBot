// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "TopBuongiornissimoBot",
    products: [
        .library(name: "TopBuongiornissimoBot", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),

        .package(url: "https://github.com/rapierorg/telegram-bot-swift.git", from: "1.2.0"),
        .package(url: "https://github.com/rapierorg/telegram-bot-swift-vapor-provider.git", from: "0.2.0"),
        .package(url: "https://github.com/IBM-Swift/swift-html-entities.git", from: "3.0.0"),
        .package(url: "https://github.com/MihaelIsaev/VaporCron.git", from:"1.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            "FluentPostgreSQL",
            "Vapor",
            "TelegramBotSDK",
            "TelegramBotSDKVaporProvider",
            "HTMLEntities",
            "VaporCron"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)


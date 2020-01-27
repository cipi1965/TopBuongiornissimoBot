import FluentPostgreSQL
import Vapor
import TelegramBotSDKVaporProvider

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let postgres = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig(url: "postgresql://cipi1965@localhost/topbuongiornissimobot")!)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(migration: CreateUser.self, database: .psql)
    migrations.add(migration: CreateGroup.self, database: .psql)
    migrations.add(migration: CreateRecord.self, database: .psql)
    migrations.add(migration: AddCazzaroMode.self, database: .psql)
    services.register(migrations)

    services.register(TelegramBotConfig(apiToken: "token", routerConfiguration: configureTelegramRouter))
    try services.register(TelegramBotProvider())
    
    Group.defaultDatabase = .psql
    User.defaultDatabase = .psql
    Record.defaultDatabase = .psql
}

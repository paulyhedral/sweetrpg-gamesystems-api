import Authentication
import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(SessionsMiddleware.self) // Enables sessions.
     middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    configureDatabase(&services)

    /// Configure migrations
    var migrations = MigrationConfig()
//    migrations.add(model: User.self, database: .sqlite)
//    migrations.add(model: UserToken.self, database: .sqlite)
//    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)

}

private func configureDatabase(_ services : inout Services) {
    // Get database environment
    let dbHostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let dbPort = Int(Environment.get("DATABASE_PORT") ?? "5432")
    let dbName = Environment.get("DATABASE_NAME") ?? "sweetrpg"
    let dbUsername = Environment.get("DATABASE_USERNAME") ?? "sweetrpg"
    let dbPassword = Environment.get("DATABASE_PASSWORD") ?? "password"

    // Configure a PostgreSQL database
    let dbConfig = PostgreSQLDatabaseConfig(hostname: dbHostname,
                                            port: dbPort,
                                            username: dbUsername,
                                            database: dbName,
                                            password: dbPassword)
    let database = try PostgreSQLDatabase(config: dbConfig)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.enableLogging(on: .postgresql)
    databases.add(database: database, as: .postgresql)
    services.register(databases)

}

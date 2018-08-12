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
configureMigrations(&services)

}

private func configureDatabase(_ services : inout Services) {
    // Get database environment
    let dbHostname = Environment.get("POSTGRES_HOSTNAME") ?? "localhost"
    let dbName = Environment.get("POSTGRES_DB") ?? "sweetrpg"
    let dbUsername = Environment.get("POSTGRES_USER") ?? "sweetrpg"
    let dbPassword = Environment.get("POSTGRES_PASSWORD") ?? "password"

    // Configure a PostgreSQL database
    let dbConfig = PostgreSQLDatabaseConfig(hostname: dbHostname,
                                            port: 5432,
                                            username: dbUsername,
                                            database: dbName,
                                            password: dbPassword)
    let database = PostgreSQLDatabase(config: dbConfig)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.enableLogging(on: .psql)
    databases.add(database: database, as: .psql)
    services.register(databases)

}

private func configureMigrations(_ services : inout Services) {
        /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: GameSystemModel.self, database: .psql)
//    migrations.add(model: UserToken.self, database: .sqlite)
//    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)
}

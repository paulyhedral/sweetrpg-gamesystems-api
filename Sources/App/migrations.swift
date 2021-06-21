//
// Created by Paul Schifferer on 6/16/21.
//

import Vapor
import Fluent


public func migrations(_ app : Application) throws {
    // app.migrations.add(SeedDatabase())

    switch app.environment {
    case .development, .testing:
        // TODO: non-production migrations
        break
    default:
        break
    }

    app.migrations.add(CacheEntry.migration)

    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
}

import Vapor
import FluentPostgreSQL


 final class GameSystemModel : PostgreSQLModel {
     var id : Int?
 var identifier : String
 var name : String
 var details : String
 var edition : String

 init(identifier : String, name : String, details : String = "", edition : String = "1") {
    self.identifier = identifier
    self.name = name
    self.details = details
    self.edition = edition
}
}

extension GameSystemModel : Migrations {}

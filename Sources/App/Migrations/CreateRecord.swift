//
//  CreateRecord.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CreateRecord: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.create(Record.self, on: conn, closure: { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.date)
            builder.field(for: \.userId)
            builder.field(for: \.groupId)
            
            builder.reference(from: \.userId, to: \User.id)
            builder.reference(from: \.groupId, to: \Group.id)
        })
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.delete(Record.self, on: conn)
    }
}

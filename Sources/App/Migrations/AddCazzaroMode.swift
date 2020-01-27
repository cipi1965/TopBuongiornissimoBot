//
//  AddCazzaroMode.swift
//  App
//
//  Created by Matteo Piccina on 26/08/2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct AddCazzaroMode: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Group.self, on: conn, closure: { (builder) in
            let defaultValue = PostgreSQLColumnConstraint.default(.literal(PostgreSQLLiteral.boolean(PostgreSQLBoolLiteral.false)))
            builder.field(for: \.cazzaroMode, type: .bool, defaultValue)
        })
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Group.self, on: conn, closure: { (builder) in
            builder.deleteField(for: \.cazzaroMode)
        })
    }
}

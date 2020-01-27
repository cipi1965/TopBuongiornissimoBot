//
//  CreateGroup.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CreateGroup: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.create(Group.self, on: conn, closure: { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.chatId)
            builder.field(for: \.name)
            builder.field(for: \.disableMessages)
            builder.field(for: \.showOnRanking)
        })
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.delete(Group.self, on: conn)
    }
}

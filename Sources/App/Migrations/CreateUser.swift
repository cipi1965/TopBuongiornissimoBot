//
//  CreateUser.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CreateUser: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.create(User.self, on: conn, closure: { (builder) in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.telegramId)
            builder.field(for: \.chatId)
            builder.field(for: \.username)
            builder.field(for: \.firstName)
            builder.field(for: \.lastName)
        })
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.delete(User.self, on: conn)
    }
}

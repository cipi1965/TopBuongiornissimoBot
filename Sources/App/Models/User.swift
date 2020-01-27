//
//  User.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import FluentPostgreSQL
import Vapor
import TelegramBotSDK

final class User: PostgreSQLModel {
    static let entity = "users"
    
    var id: Int?
    var telegramId: Int
    var chatId: Int?
    var username: String?
    var firstName: String?
    var lastName: String?
    
    init(id: Int? = nil, telegramId: Int, chatId: Int?, username: String? = nil, firstName: String? = nil, lastName: String? = nil) {
        self.id = id
        self.telegramId = telegramId
        self.chatId = chatId
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension User {
    var records: Children<User, Record> {
        return children(\.userId)
    }
}

extension User {
    static func findOrCreate(user telegramUser: TelegramBotSDK.User, from chat: TelegramBotSDK.Chat, on connection: DatabaseConnectable) throws -> User {
        var user = try query(on: connection).filter(\.telegramId == Int(telegramUser.id)).first().wait()
        guard user == nil else { return user! }
        
        let chatId = chat.type == .private_chat ? Int(chat.id) : nil
        
        user = User(
            id: nil,
            telegramId: Int(telegramUser.id),
            chatId: chatId,
            username: telegramUser.username,
            firstName: telegramUser.firstName,
            lastName: telegramUser.lastName
        )
        return try user!.create(on: connection).wait()
    }
}


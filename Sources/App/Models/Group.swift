//
//  Group.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import FluentPostgreSQL
import Vapor
import TelegramBotSDK

final class Group: PostgreSQLModel {
    static let entity = "groups"
    
    var id: Int?
    var name: String
    var chatId: Int
    var disableMessages: Bool
    var showOnRanking: Bool
    var cazzaroMode: Bool
    
    init(id: Int?, name: String, chatId: Int, disableMessages: Bool = false, showOnRanking: Bool = true, cazzaroMode: Bool = false) {
        self.id = id
        self.name = name
        self.chatId = chatId
        self.disableMessages = disableMessages
        self.showOnRanking = showOnRanking
        self.cazzaroMode = cazzaroMode
    }
}

extension Group {
    var records: Children<Group, Record> {
        return children(\.groupId)
    }
}

extension Group {
    static func findOrCreate(chat: TelegramBotSDK.Chat, on connection: DatabaseConnectable) throws -> Group {
        var group = try query(on: connection).filter(\.chatId == Int(chat.id)).first().wait()
        guard group == nil else { return group! }
        
        group = Group(id: nil, name: chat.title!, chatId: Int(chat.id), disableMessages: false)
        return try group!.create(on: connection).wait()
    }
}

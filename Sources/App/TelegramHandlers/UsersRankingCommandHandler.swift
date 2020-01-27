//
//  UsersRankingCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import Vapor
import TelegramBotSDK
import FluentPostgreSQL
import HTMLEntities

class UsersRankingCommandHandler {
    static func run(context: Context) -> Bool {
        guard let request = context.vaporRequest else { return false }
        let message = context.update.message!
        
        if message.chat.type == .group || message.chat.type == .supergroup {
            DispatchQueue.global().async {
                
                let group = try! Group.findOrCreate(chat: message.chat, on: request)
                
                let conn = try! request.requestPooledConnection(to: .psql).wait()
                let results = try! conn.raw("""
                SELECT
                    records."userId",
                    records."count",
                    users."firstName",
                    users."lastName",
                    users."username",
                    users."telegramId"
                FROM
                (
                    SELECT "userId", count(*) as count
                    FROM records
                    WHERE records."groupId" = \(group.id!)
                    GROUP BY records."userId"
                    ORDER BY "count" DESC
                    LIMIT 25
                ) as records
                LEFT JOIN users ON users.id = records."userId"
                """).all().wait()
                
                var message = "<b>Classifica:</b>\n\n"
                
                for result in results {
                    let username = try? result.firstValue(name: "username")!.decode(String.self)
                    let telegramId = (try! result.firstValue(name: "telegramId")!.decode(Int.self))
                    let firstName = (try? result.firstValue(name: "firstName")!.decode(String.self))!
                    let lastName = (try? result.firstValue(name: "lastName")!.decode(String.self)) ?? ""
                    let count = try? result.firstValue(name: "count")!.decode(Int.self)
                    
                    var link = ""
                    if let username = username {
                        link = "https://t.me/\(username)"
                    } else {
                        link = "tg://user?id=\(telegramId)"
                    }
                    
                    message += "<a href=\"\(link)\">\(firstName.htmlEscape()) \(lastName.htmlEscape())</a>: \(count ?? 0)\n"
                }
                
                context.respondAsync(message, parse_mode: "HTML", disable_web_page_preview: true)
            }
        } else {
            context.respondAsync("Questo comando è utilizzabile solo nei gruppi")
        }
        
        return true
    }
}

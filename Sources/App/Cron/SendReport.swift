//
//  SendReport.swift
//  App
//
//  Created by Matteo Piccina on 22/08/2019.
//

import Foundation
import Vapor
import VaporCron
import FluentPostgreSQL
import TelegramBotSDKVaporProvider

struct SendReport: VaporCronSchedulable {
    static var expression: String {
        let hoursFromGMT = TimeZone.current.secondsFromGMT() / 3600
        return "0 \(22 - hoursFromGMT) * * *"
    }
    
    static func task(on container: VaporCronContainer) -> EventLoopFuture<Void> {
        return container.requestCachedConnection(to: .psql).flatMap { conn in
            return Group.query(on: conn).filter(\.disableMessages == false).all().flatMap({ (groups) throws in
                let telegramClient = try container.make(TelegramBotClient.self)
                
                return groups.map { group -> EventLoopFuture<Void> in
                    return conn.raw("""
                    SELECT count(*) as count
                    FROM records
                    WHERE records."groupId" = \(group.id!)
                    """).first().map({ (result) throws in
                        let count = try result!.firstValue(name: "count")!.decode(Int.self)
                        let plural = count == 1 ? "buongiorno" : "buongiorni"
                        let message = "Oggi la vita di \(group.name) è stata allietata da ben \(count) \(plural).\nA domani ☕️"
                        
                        telegramClient.bot.sendMessageAsync(chatId: Int64(group.chatId), text: message)
                    })
                }.flatten(on: container)
            })
        }
    }
}

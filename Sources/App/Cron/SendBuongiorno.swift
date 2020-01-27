//
//  SendBuongiorno.swift
//  App
//
//  Created by Matteo Piccina on 22/08/2019.
//

import Foundation
import Vapor
import VaporCron
import FluentPostgreSQL
import TelegramBotSDKVaporProvider

struct SendBuongiorno: VaporCronSchedulable {
    static var expression: String {
        let hoursFromGMT = TimeZone.current.secondsFromGMT() / 3600
        return "0 \(7 - hoursFromGMT) * * *"
    }
    
    static func task(on container: VaporCronContainer) -> EventLoopFuture<Void> {
        return container.requestCachedConnection(to: .psql).flatMap { conn in
            return Group.query(on: conn).filter(\.disableMessages == false).all().map { (groups) throws in
                let telegramClient = try container.make(TelegramBotClient.self)
                
                groups.forEach { group in
                    telegramClient.bot.sendMessageAsync(chatId: Int64(group.chatId), text: "Buongiorno ☕️")
                }
            }
        }
    }
}

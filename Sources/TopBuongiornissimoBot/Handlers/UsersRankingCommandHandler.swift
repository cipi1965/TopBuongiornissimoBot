//
//  UsersRankingCommandHandler.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 31/10/17.
//

import Foundation
import TelegramBotSDK
import Meow
import HTMLEntities

class UsersRankingCommandHandler: Handler {
    static func run(context: Context) -> Bool {
        let message = context.update.message!
        
        if message.chat.type == .group || message.chat.type == .supergroup {
            let groupId = message.chat.id
            let group = try! Group.findOrCreate(name: message.chat.title!, chatId: Int(groupId))
            
            let sort: Sort = [
                "count": .descending
            ]
            
            let counters = try! UserCounter.find([
                "group": group._id
                ] as Query, sortedBy: sort, limitedTo: 25)
            
            var message = "<b>Classifica:</b>\n\n"
            
            for counter in counters {
                let user = try! counter.user?.resolve()
                
                if let user = user {
                    var link = ""
                    if user.username != "" {
                        link = "https://t.me/\(user.username)"
                    } else {
                        link = "tg://user?id=\(user.telegramId)"
                    }
                    
                    message += "<a href=\"\(link)\">\(user.name.htmlEscape()) \(user.surname.htmlEscape())</a>: \(counter.count)\n"
                }
            }
            
            context.respondAsync(message, parse_mode: "HTML", disable_web_page_preview: true)
        }
        
        return true
    }
}

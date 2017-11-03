//
//  GroupsCommand.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 31/10/17.
//

import Foundation
import TelegramBotSDK
import Meow

class GroupsRankingCommandHandler: Handler {
    
    static func run(context: Context) -> Bool {
        let sort: Sort = [
            "count": .descending
        ]
        
        let counters = try! GroupCounter.find(sortedBy: sort, limitedTo: 25)
        
        var message = "<b>Classifica Gruppi:</b>\n\n"
        
        for counter in counters {
            let group = try! counter.group.resolve()
            message += "\(group.name.htmlEscape()): \(counter.count)\n"
        }
        
        context.respondAsync(message, parse_mode: "HTML")
        
        return false
    }
}

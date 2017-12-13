//
//  DisableReportsCommandHandler.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 13/12/17.
//

import Foundation
import TelegramBotSDK

class DisableReportsCommandHandler: Handler {
    static func run(context: Context) -> Bool {
        if !context.privateChat {
            let message = context.update.message!
            let groupId = message.chat.id
            let group = try! Group.findOrCreate(name: message.chat.title!, chatId: Int(groupId))
            
            if group.disableMessages {
                group.disableMessages = false
                try! group.save()
                context.respondAsync("Il bot non invierà più messaggi automatici 😢")
            } else {
                group.disableMessages = true
                try! group.save()
                context.respondAsync("Il bot incomincerà nuovamente a mandare i messaggi automatici! 😚 ")
            }
            
            return true
        }
        
        return false
    }
}

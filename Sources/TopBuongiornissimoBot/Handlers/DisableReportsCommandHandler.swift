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
            
            let chatMembersResult = context.bot.getChatAdministratorsSync(chat_id: context.chatId!)
            
            guard let chatAdmins = chatMembersResult else { return false }
            
            var validUser = false
            
            for chatMember in chatAdmins {
                if chatMember.user.id == context.fromId && (chatMember.can_change_info ?? false || chatMember.status_string == "creator") {
                    validUser = true
                }
            }
            
            guard validUser else { return false }
            
            if !group.disableMessages {
                group.disableMessages = true
                try! group.update(fields: ["disableMessages"])
                context.respondAsync("Il bot non invierà più messaggi automatici 😢")
            } else {
                group.disableMessages = false
                try! group.update(fields: ["disableMessages"])
                context.respondAsync("Il bot incomincerà nuovamente a mandare i messaggi automatici! 😚 ")
            }
            
            return true
        }
        
        return false
    }
}

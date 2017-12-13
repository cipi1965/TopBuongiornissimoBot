//
//  DisableMessagesCommandHandler.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 21/11/17.
//

import Foundation
import TelegramBotSDK

class DisableMessagesCommandHandler: Handler {
    static func run(context: Context) -> Bool {
        if !context.privateChat {
            let message = context.update.message!
            let groupId = message.chat.id
            let group = try! Group.findOrCreate(name: message.chat.title!, chatId: Int(groupId))
            let groupCounter = try! GroupCounter.findOrCreate(group: group)
            
            let chatMembersResult = context.bot.getChatAdministratorsSync(chat_id: context.chatId!)
            print(chatMembersResult)
            print(context.fromId)
            
            guard let chatAdmins = chatMembersResult else { return false }
            
            var validUser = false
            
            for chatMember in chatAdmins {
                if chatMember.user.id == context.fromId && (chatMember.can_change_info ?? false || chatMember.status_string == "creator") {
                    validUser = true
                }
            }
            
            guard validUser else { return false }
            
            if groupCounter.displayOnTop {
                groupCounter.displayOnTop = false
                try! groupCounter.update(fields: ["displayOnTop"])
                
                context.respondAsync("Il gruppo verrà da ora nascosto dalla classifica globale")
            } else {
                groupCounter.displayOnTop = true
                try! groupCounter.update(fields: ["displayOnTop"])
                context.respondAsync("Il gruppo verrà da ora mostrato dalla classifica globale")
            }
            
            return true
        }
        
        return false
    }
}

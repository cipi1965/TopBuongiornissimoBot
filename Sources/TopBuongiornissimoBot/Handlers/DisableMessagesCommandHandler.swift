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
            
            if groupCounter.displayOnTop {
                groupCounter.displayOnTop = false
                try! groupCounter.save()
                context.respondAsync("Il gruppo verrà da ora nascosto dalla classifica globale")
            } else {
                groupCounter.displayOnTop = true
                try! groupCounter.save()
                context.respondAsync("Il gruppo verrà da ora mostrato dalla classifica globale")
            }
            
            return true
        }
        
        return false
    }
}

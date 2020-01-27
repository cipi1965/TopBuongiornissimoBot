//
//  DisableMessagesCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 22/08/2019.
//

import Foundation
import Vapor
import TelegramBotSDK
import FluentPostgreSQL
import HTMLEntities

class DisableRankingCommandHandler {
    static func run(context: Context) -> Bool {
        guard let request = context.vaporRequest else { return false }
        let message = context.update.message!
        
        guard !context.privateChat else {
            context.respondAsync("Questo comando è utilizzabile solo nei gruppi")
            return true
        }
        
        DispatchQueue.global().async {
            let group = try! Group.findOrCreate(chat: message.chat, on: request)
            
            let chatMembersResult = context.bot.getChatAdministratorsSync(chatId: context.chatId!)
            guard let chatAdmins = chatMembersResult else { return }
            var validUser = false
            
            for chatMember in chatAdmins {
                if chatMember.user.id == context.fromId && (chatMember.canChangeInfo ?? false || chatMember.status == .creator) {
                    validUser = true
                }
            }
            
            guard validUser else { return }
            
            if group.showOnRanking {
                group.showOnRanking = false
                _ = try! group.save(on: request).wait()
                
                context.respondAsync("Il gruppo verrà da ora nascosto dalla classifica globale")
            } else {
                group.showOnRanking = true
                _ = try! group.save(on: request).wait()
                context.respondAsync("Il gruppo verrà da ora mostrato dalla classifica globale")
            }
        }
        
        return true
    }
}

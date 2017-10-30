//
//  main.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import TelegramBotSDK
import Meow

let bot = TelegramBot(token: "341980331:AAGkxNuLxkiF9UGg3J29ILPqBVQHD7yEf_M")
try! Meow.init("mongodb://localhost/topbuongiornissimobot")

let router = Router(bot: bot)

router[.text] = { context in
    
    guard let message = context.update.message else { return false }
    
    switch message.chat.type {
    case .private_chat:
        
        return false 
        
    case .group,
         .supergroup:
        
        let groupId = message.chat.id
        let group = try! Group.findOrCreate(name: message.chat.title!, chatId: Int(groupId))
        
        let from = message.from!
        let user = try! User.findOrCreate(telegramId: Int(from.id), name: from.first_name, surname: from.last_name ?? "", username: from.username ?? "")
        
        if message.text!.range(of: "(buongiorno|buondì|olà)", options: [.regularExpression, .caseInsensitive]) != nil {
            let counter = try! UserCounter.findOrCreate(group: group, user: user)
            let groupCounter = try! GroupCounter.findOrCreate(group: group)
            
            if !Calendar.current.isDate(Date(), inSameDayAs: counter.last) {
                counter.count += 1
                counter.last = Date()
                groupCounter.count += 1
                try! counter.save()
                try! groupCounter.save()
            }
        }
        
        return false
        
    default:
        return false
    }
}

router["classifica"] = { context in
    
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
        
        var message = "Classifica:\n\n"
        
        for counter in counters {
            let user = try! counter.user?.resolve()
            
            if let user = user {
                var link = ""
                if user.username != "" {
                    link = "https://t.me/\(user.username)"
                } else {
                    link = "tg://user?id=\(user.telegramId)"
                }
                
                message += "[\(user.name) \(user.surname)](\(link)): \(counter.count)\n"
            }
        }
        
        context.respondAsync(message, parse_mode: "Markdown", disable_web_page_preview: true)
    }
    
    return false
}

router["gruppi"] = { context in
        
    let sort: Sort = [
        "count": .descending
    ]
    
    let counters = try! GroupCounter.find(sortedBy: sort, limitedTo: 25)
    
    var message = "Classifica Gruppi:\n\n"
    
    for counter in counters {
        let group = try! counter.group.resolve()
        message += "\(group.name): \(counter.count)\n"
    }
    
    context.respondAsync(message, parse_mode: "Markdown")
    
    return false
}

while let update = bot.nextUpdateSync() {
    try router.process(update: update)
}

fatalError("Server stopped due to error: \(bot.lastError)")

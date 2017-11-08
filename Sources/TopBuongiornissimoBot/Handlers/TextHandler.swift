//
//  TextHandler.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 31/10/17.
//

import Foundation
import TelegramBotSDK
import Meow

class TextHandler: Handler {
    static func run(context: Context) -> Bool {
        guard let message = context.update.message else { return false }
        
        switch message.chat.type {
        case .private_chat:
            
            return true
            
        case .group,
             .supergroup:
            
            let groupId = message.chat.id
            let group = try! Group.findOrCreate(name: message.chat.title!, chatId: Int(groupId))
            
            let from = message.from!
            let user = try! User.findOrCreate(telegramId: Int(from.id), name: from.first_name, surname: from.last_name ?? "", username: from.username ?? "")
            
            if BuongiornoChecker.check(message: message.text!) {
                let counter = try! UserCounter.findOrCreate(group: group, user: user)
                let groupCounter = try! GroupCounter.findOrCreate(group: group)
                let dailyCounter = try! DailyGroupCounter.findOrCreate(group: group, day: Date())
                
                let curDate = Date()
                let startDate = curDate.setting(hour: 5, minute: 0, second: 0)
                let endDate = curDate.setting(hour: 14, minute: 0, second: 0)
                
                guard startDate!.compare(curDate) == curDate.compare(endDate!) else { return false }
                
                if !Calendar.current.isDate(curDate, inSameDayAs: counter.last) {
                    counter.count += 1
                    counter.last = Date()
                    groupCounter.count += 1
                    dailyCounter.count += 1
                    try! counter.save()
                    try! groupCounter.save()
                    try! dailyCounter.save()
                }
            }
            
            return true
            
        default:
            return true
        }
    }
}

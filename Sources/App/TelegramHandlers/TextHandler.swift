import Foundation
import Vapor
import FluentPostgreSQL
import TelegramBotSDK
import TelegramBotSDKVaporProvider

class TextHandler {
    static func run(context: Context) throws -> Bool {
        guard let request = context.vaporRequest else { return false }
        guard let message = context.update.message else { return false }
        
        
        switch message.chat.type {
        case .private_chat:
            DispatchQueue.global().async {
                try! User.findOrCreate(user: message.from!, from: message.chat, on: request)
            }
            
            return false
        case .group,
             .supergroup:
            DispatchQueue.global().async {
                let group = try! Group.findOrCreate(chat: message.chat, on: request)
                let user = try! User.findOrCreate(user: message.from!, from: message.chat, on: request)
                
                if (StringsChecker.checkBuongiorno(message: message.text!)) {
                    let curDate = Date()
                    let startDate = curDate.setting(hour: 5, minute: 0, second: 0)!
                    let endDate = curDate.setting(hour: 14, minute: 0, second: 0)!
                    
                    let date12am = curDate.setting(hour: 12, minute: 0, second: 0)!
                    
                    if ((curDate > date12am || curDate < startDate) && group.cazzaroMode) {
                        context.respondAsync(CazzaroMessages.after12amMessages.randomElement()!, reply_to_message_id: message.messageId)
                    } else if (group.cazzaroMode) {
                        context.respondAsync(CazzaroMessages.buongiornoMessages.randomElement()!, reply_to_message_id: message.messageId)
                    }
                    
                    //guard startDate!.compare(curDate) == curDate.compare(endDate!) else { return }
                    
                    guard (!(try! Record.existsForUsersOnDateInGroup(user: user, group: group, date: Date(), on: request))) else {
                        return
                    }
                    
                    let newRecord = Record(id: nil, date: Date(), userId: user.id!, groupId: group.id!)
                    _ = try! newRecord.create(on: request).wait()
                }
                
                if (StringsChecker.checkFiga(message: message.text!)) {
                    context.respondAsync(CazzaroMessages.figaMessages.randomElement()!, reply_to_message_id: message.messageId)
                }
            }
            
            return true
        default:
            return true
        }
    }
}

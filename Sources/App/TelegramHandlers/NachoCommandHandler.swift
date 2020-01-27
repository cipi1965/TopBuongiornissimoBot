//
//  NachoCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import TelegramBotSDK
import Vapor
import FluentPostgreSQL

let nachoId = 174670768

class NachoCommandHandler {
    static func run(context: Context) -> Bool {
        guard let request = context.vaporRequest else { return true }
        let random = Int.random(in: 1...3)
        
        switch random {
        case 1:
            var date = Date()
            date.addTimeInterval(2_160_000)
            let customFormat = "dd MMMM yyyy"
            
            let itLocale = Locale(identifier: "it_IT")
            let itFormat = DateFormatter.dateFormat(fromTemplate: customFormat, options: 0, locale: itLocale)
            
            let formatter = DateFormatter()
            formatter.dateFormat = itFormat
            
            let phrases = [
                "Se non ti lecchi le dita godi solo a metà",
                "Pikkolo Nacho: Easter Egg.\nDal \(formatter.string(from: date)) al cinema",
                "Kek"
            ]
            
            context.respondAsync(phrases.random!)
        case 2:
            DispatchQueue.global().async {
                
                guard let user = try! User.query(on: request).filter(\.telegramId == nachoId).first().wait() else {
                    context.respondAsync("Nacho non ha ancora usato questo bot, bastardo!")
                    return
                }
                
                let conn = try! request.requestPooledConnection(to: .psql).wait()
                let result = try! conn.raw("""
                SELECT count(*)
                FROM records
                WHERE "userId" = \(user.id!)
                """).first().wait()
                let count = (try? result!.firstValue(name: "count")!.decode(Int.self)) ?? 0
                
                context.respondAsync("Nacho ha totalizzato \(count) buongiorni! Lode a Nacho!")
            }
        case 3:
            DispatchQueue.global().async {
                
                guard let user = try! User.query(on: request).filter(\.telegramId == nachoId).first().wait() else {
                    context.respondAsync("Nacho non ha ancora usato questo bot, bastardo!")
                    return
                }
                
                let startDate = Date().setting(hour: 0, minute: 0, second: 0)!
                let endDate = Date().setting(hour: 23, minute: 59, second: 59)!
                let count = try! user.records.query(on: request).filter(\.date > startDate).filter(\.date < endDate).count().wait()
                if (count > 0) {
                    context.respondAsync("Nacho oggi ha inviato \(count) buongiorni! Lode a Nacho!")
                } else {
                    context.respondAsync("Nacho oggi non ha invitato buongiorni. Probabilmente non è in vena 😐")
                }
            }
        default:
            context.respondAsync("Boom")
        }
        
        return true
    }
}

//
//  main.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import TelegramBotSDK
import Meow
import Dispatch
import Commander
import DotEnv
import Vapor
import SwiftyJSON

let env = DotEnv(withFile: ".env")

print(FileManager.default.currentDirectoryPath)

let token = env.get("BOT_TOKEN")
let mongoDbString = env.get("MONGODB_CONNECTION")

if token == nil || mongoDbString == nil {
    print("Please set BOT_TOKEN and MONGODB_CONNECTION in .env file")
    exit(1)
}

let bot = TelegramBot(token: token!)
try! Meow.init(mongoDbString!)

let main = Commander.Group {
    $0.command("serve", {
        
        let drop = try Droplet()
        
        let router = Router(bot: bot)
        router["start"] = StartCommandHandler.run
        router["classifica"] = UsersRankingCommandHandler.run
        router["gruppi"] = GroupsRankingCommandHandler.run
        router[.text] = TextHandler.run
        router.partialMatch = { context in
            return true
        }
        router.unsupportedContentType = { context in
            return true
        }
        router.unmatched = { context in
            return true
        }
        
        drop.post("topbuongiornissimobot", "webhook") { req in
            
            if let bytes = req.body.bytes {
                let jsonString = String(bytes: bytes)
                let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = SwiftyJSON.JSON(data: data!)
                
                let update = Update(json: json)
                DispatchQueue.global().async {
                    try! router.process(update: update)
                }
            }
            
            return "OK"
        }
        
        try drop.run()
    })
    
    $0.command("sendbuongiorno", {
        let groups = try Group.find("disableMessages" == false)

        for group in groups {
            bot.sendMessageSync(Int64(group.chatId), "Buongiorno ☕️")
        }
    })
    
    $0.command("sendreport", {
        let groups = try Group.find("disableMessages" == false)
        
        for group in groups {
            let dailyCounter = try DailyGroupCounter.findOrCreate(group: group, day: Date())
            
            var translation = ""
            if dailyCounter.count == 1 {
                translation = "buongiorno"
            } else {
                translation = "buongiorni"
            }
            
            bot.sendMessageSync(Int64(group.chatId), "Oggi la vita di \(group.name) è stata allietata da ben \(dailyCounter.count) \(translation).\nA domani ☕️")
        }
    })
}

main.run()

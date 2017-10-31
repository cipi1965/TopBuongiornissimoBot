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

let bot = TelegramBot(token: "341980331:AAGkxNuLxkiF9UGg3J29ILPqBVQHD7yEf_M")
try! Meow.init("mongodb://localhost/topbuongiornissimobot")

let main = Commander.Group {
    $0.command("serve", {
        let router = Router(bot: bot)
        router[.text] = TextHandler.run
        router["classifica"] = UsersRankingCommandHandler.run
        router["gruppi"] = GroupsRankingCommandHandler.run
        
        while let update = bot.nextUpdateSync() {
            DispatchQueue.global().async {
                try! router.process(update: update)
            }
        }
        
        fatalError("Server stopped due to error: \(bot.lastError!)")
    })
    
    $0.command("sendbuongiorno", {
        let groups = try Group.find()

        for group in groups {
            bot.sendMessageSync(Int64(group.chatId), "Buongiorno")
        }
    })
}

main.run()

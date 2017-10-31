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

//
//  telegram.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import TelegramBotSDK

func configureTelegramRouter(_ router: Router) {
    router["greet", .slashRequired] = { context in
        context.respondSync("Test")
        return true
    }
    router["start", .slashRequired] = StartCommandHandler.run
    router["classifica utenti", .slashRequired] = UsersRankingCommandHandler.run
    router["classifica gruppi", .slashRequired] = GroupsRankingCommandHandler.run
    router["classifica", .slashRequired] = RankingHelpCommandHandler.run
    router["nacho", .slashRequired] = NachoCommandHandler.run
    router["toggleclassifica", .slashRequired] = DisableRankingCommandHandler.run
    router["togglemessaggi", .slashRequired] = DisableReportsCommandHandler.run
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
}

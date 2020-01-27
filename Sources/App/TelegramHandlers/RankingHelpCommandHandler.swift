//
//  RankingHelpCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 22/08/2019.
//

import Foundation
import TelegramBotSDK

class RankingHelpCommandHandler {
    static func run(context: Context) -> Bool {
        let message = """
        <b>Le classifiche disponibilisono le seguenti:</b>
        
        <code>- /classifica utenti
        - /classifica gruppi</code>
        """
        context.respondAsync(message, parse_mode: "HTML")
        return true
    }
}

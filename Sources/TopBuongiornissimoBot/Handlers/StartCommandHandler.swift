//
//  StartCommandHandler.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 08/11/17.
//

import Foundation
import TelegramBotSDK

class StartCommandHandler: Handler {
    static func run(context: Context) -> Bool {
        guard context.privateChat else { return false }
        
        context.respondAsync("Buongiornissimo ☕️!\n\nQuesto bot serve a conteggiare i buongiorno scritti nei gruppi, inoltre stila due tipi di classifica:\n• /classifica - Classifica degli utenti per gruppo\n• /gruppi - Classifica globale dei gruppi\n\nPer avviarlo basta aggiungerlo in un gruppo")
        
        return true
    }
}

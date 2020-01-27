//
//  StartCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import TelegramBotSDK

class StartCommandHandler {
    static func run(context: Context) -> Bool {
        guard context.privateChat else { return false }
        
        context.respondAsync("Buongiornissimo ☕️!\n\nQuesto bot serve a conteggiare i buongiorno scritti nei gruppi, inoltre stila due tipi di classifica:\n• /classifica - Classifica degli utenti per gruppo\n• /gruppi - Classifica globale dei gruppi\n• /toggleclassifica - Rimuove/aggiunge il gruppo dalla classifica globale\n• /togglemessaggi - Disabilita/abilita i messaggi automatici nel gruppo\n\nPer avviarlo basta aggiungerlo in un gruppo")
        
        return true
    }
}

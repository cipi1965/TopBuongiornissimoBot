//
//  Handler.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 31/10/17.
//

import Foundation
import TelegramBotSDK

protocol Handler {
    static func run(context: Context) -> Bool
}

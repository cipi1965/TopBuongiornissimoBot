//
//  Group.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import Meow

final class Group: Model {
    var _id = ObjectId()
    
    var name: String
    var chatId: Int
    
    init(name: String, chatId: Int) {
        self.name = name
        self.chatId = chatId
    }
}

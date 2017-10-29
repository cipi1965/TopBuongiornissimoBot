//
//  User.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import Meow

final class User: Model {
    var _id = ObjectId()
    
    var telegramId: Int
    var name: String
    var surname: String
    var username: String
    
    init(telegramId: Int, name: String, surname: String, username: String) {
        self.telegramId = telegramId
        self.name = name
        self.surname = surname
        self.username = username
    }
}

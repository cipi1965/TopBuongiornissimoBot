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
    
    class func findOrCreate(telegramId: Int, name: String, surname: String, username: String) throws -> User {
        
        let user = try User.findOne("telegramId" == telegramId)
        
        if let user = user {
            user.name = name
            user.surname = surname
            user.username = username
            try user.save()
            return user
        } else {
            let user = User(telegramId: telegramId, name: name, surname: surname, username: username)
            try user.save()
            return user
        }
        
    }
}

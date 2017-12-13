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
    var disableMessages: Bool
    
    init(name: String, chatId: Int) {
        self.name = name
        self.chatId = chatId
        self.disableMessages = false
    }
    
    class func findOrCreate(name: String, chatId: Int) throws -> Group {
        
        let group = try Group.findOne("chatId" == chatId)
        
        if let group = group {
            group.name = name
            try group.save()
            return group
        } else {
            let group = Group(name: name, chatId: chatId)
            try group.save()
            return group
        }
        
    }
}

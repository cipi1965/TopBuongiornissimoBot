//
//  UserCounter.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import Meow

final class UserCounter: Model {
    var _id = ObjectId()
    
    var group: Reference<Group>?
    var user: Reference<User>?
    var count: Int
    var last: Date
    
    init(group: Reference<Group>, user: Reference<User>, count: Int, last: Date) {
        self.group = group
        self.user = user
        self.count = count
        self.last = last
    }
    
    class func findOrCreate(group: Group, user: User) throws -> UserCounter {
        let counter = try UserCounter.findOne([
            "group": group._id,
            "user": user._id
        ] as Query)
        
        if let counter = counter {
            return counter
        } else {
            let counter = UserCounter(group: Reference(to: group), user: Reference(to: user), count: 0, last: Date(timeIntervalSince1970: 0))
            try counter.save()
            return counter
        }
    }
}

//
//  GroupCounter.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 29/10/17.
//

import Foundation
import Meow

final class GroupCounter: Model {
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
}

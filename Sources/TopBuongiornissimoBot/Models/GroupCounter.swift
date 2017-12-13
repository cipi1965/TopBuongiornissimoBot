//
//  File.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 30/10/17.
//

import Foundation
import Meow

final class GroupCounter: Model {
    var _id = ObjectId()
    
    var group: Reference<Group>
    var count: Int
    var displayOnTop: Bool
    
    init(group: Reference<Group>, count: Int) {
        self.group = group
        self.count = count
        self.displayOnTop = true
    }
    
    class func findOrCreate(group: Group) throws -> GroupCounter {
        let counter = try GroupCounter.findOne([
            "group": group._id
            ] as Query)
        
        if let counter = counter {
            return counter
        } else {
            let counter = GroupCounter(group: Reference(to: group), count: 0)
            try counter.save()
            return counter
        }
    }
}

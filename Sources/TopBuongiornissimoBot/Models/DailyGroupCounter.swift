//
//  DailyCounter.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 02/11/17.
//

import Foundation
import Meow

final class DailyGroupCounter: Model {
    var _id = ObjectId()
    
    var group: Reference<Group>
    var day: Date
    var count: Int
    
    init(group: Reference<Group>, day: Date, count: Int) {
        self.group = group
        self.day = Calendar(identifier: .gregorian).startOfDay(for: day)
        self.count = count
    }
    
    class func findOrCreate(group: Group, day: Date) throws -> DailyGroupCounter {
        
        let startOfDay = Calendar(identifier: .gregorian).startOfDay(for: day)
        
        let counter = try DailyGroupCounter.findOne([
            "group": group._id,
            "day": startOfDay
            ] as Query)
        
        if let counter = counter {
            return counter
        } else {
            let counter = DailyGroupCounter(group: Reference(to: group), day: startOfDay, count: 0)
            try counter.save()
            return counter
        }
    }
    
}

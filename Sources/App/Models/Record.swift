//
//  Record.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Record: PostgreSQLModel {
    static let entity = "records"
    
    var id: Int?
    var date: Date
    
    var userId: Int
    var groupId: Int
    
    public init(id: Int?, date: Date, userId: Int, groupId: Int) {
        self.id = id
        self.date = date
        self.userId = userId
        self.groupId = groupId
    }
}

extension Record {
    var user: Parent<Record, User> {
        return parent(\.userId)
    }
    var group: Parent<Record, Group> {
        return parent(\.groupId)
    }
}

extension Record {
    static func existsForUsersOnDateInGroup(user: User, group: Group, date: Date, on connection: DatabaseConnectable) throws -> Bool {
        let startDate = date.setting(hour: 0, minute: 0, second: 0)!
        let endDate = date.setting(hour: 23, minute: 59, second: 59)!
        
        let record = try query(on: connection)
            .filter(\.date > startDate)
            .filter(\.date < endDate)
            .filter(\.userId == user.id!)
            .filter(\.groupId == group.id!)
            .first().wait()
        return record != nil
    }
}

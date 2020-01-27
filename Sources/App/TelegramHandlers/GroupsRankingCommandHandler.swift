//
//  GroupsRankingCommandHandler.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation
import Vapor
import TelegramBotSDK
import FluentPostgreSQL
import HTMLEntities

class GroupsRankingCommandHandler {
    static func run(context: Context) -> Bool {
        guard let request = context.vaporRequest else { return false }

        DispatchQueue.global().async {
            
            let conn = try! request.requestPooledConnection(to: .psql).wait()
            let results = try! conn.raw("""
                SELECT
                   records."groupId",
                   records."count",
                   groups."name"
                FROM
                   (
                        SELECT "groupId", count(*) as count
                        FROM records
                        GROUP BY records."groupId"
                        ORDER BY "count" DESC
                        LIMIT 25
                   ) as records
                LEFT JOIN groups ON groups.id = records."groupId"
                WHERE groups."showOnRanking" = true
                """).all().wait()
            
            var message = "<b>Classifica:</b>\n\n"
            
            for result in results {
                let name = (try? result.firstValue(name: "name")!.decode(String.self))!
                let count = (try? result.firstValue(name: "count")!.decode(Int.self)) ?? 0
                
                message += "\(name): \(count)\n"
            }
            
            context.respondAsync(message, parse_mode: "HTML", disable_web_page_preview: true)
        }
        return true
    }
}

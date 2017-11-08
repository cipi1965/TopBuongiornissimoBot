//
//  Date+Extensions.swift
//  TopBuongiornissimoBot
//
//  Created by Matteo Piccina on 08/11/17.
//

import Foundation

extension Date {
    func setting(hour: Int, minute: Int, second: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)
    }
}

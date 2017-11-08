//
//  BuongiornoChecker.swift
//  TopBuongiornissimoBotPackageDescription
//
//  Created by Matteo Piccina on 08/11/17.
//

import Foundation

class BuongiornoChecker {
    class func check(message: String) -> Bool {
        return message.range(of: "^(.*buondì|.*buongi|.*buondi|.*buondi'|.*bgiorno|.*buongiorno|.*buon giorno|.*buongiornissimo|giorno)", options: [.regularExpression, .caseInsensitive]) != nil
    }
}

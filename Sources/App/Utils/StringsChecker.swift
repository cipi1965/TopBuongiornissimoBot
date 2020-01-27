//
//  BuongiornoChecker.swift
//  App
//
//  Created by Matteo Piccina on 19/08/2019.
//

import Foundation

class StringsChecker {
    class func checkBuongiorno(message: String) -> Bool {
        return message.range(of: "^(.*buondì|.*buongi|.*buondi|.*buondi'|.*bgiorno|.*buongiorno|.*buon giorno|.*buongiornissimo|'?giorno)", options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    class func checkFiga(message: String) -> Bool {
        return message.range(of: "^.*figa", options: [.regularExpression, .caseInsensitive]) != nil
    }
}

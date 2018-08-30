//
//  OKTableViewRegistrar+Registration.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/30/18.
//

import Foundation

extension OKTableViewRegistrar {
    enum Registration: Hashable {
        case cell(className: String, identifier: String)
        case view(className: String, identifier: String)
        
        func hasSameIdentifier(_ registration: Registration) -> Bool {
            switch (self, registration) {
            case let (.cell(_, identifier1), .cell(_, identifier2)):
                return identifier1 == identifier2
            case let (.view(_, identifier1), .view(_, identifier2)):
                return identifier1 == identifier2
            default:
                return false
            }
        }
    }
}

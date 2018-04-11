//
//  TimeInterval+SecondConversion.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension Int {
    var timeText: String {
        
        func truncatePlural(for text: String, time: Int) -> String {
            if time == 1 {
                return text.replacingOccurrences(of: "S", with: "")
            }
            return text
        }
        
        switch self {
        case 0...60:
            let text = "\(self) SECONDS AGO"
            return truncatePlural(for: text, time: self)
        case 60...3599:
            let minutes = self / 60
            let text = "\(minutes) MINUTES AGO"
            return truncatePlural(for: text, time: minutes)
        case 3600...86399:
            let hours = self / 3600
            let text = "\(hours) HOURS AGO"
            return truncatePlural(for: text, time: hours)
        default:
            let days = self / 86400
            let text = "\(days) DAYS AGO"
            return truncatePlural(for: text, time: days)
        }
    }
}

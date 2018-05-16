//
//  TimeInterval+SecondConversion.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var timeText: String {
        
        let seconds = Int(floor(self))
        
        switch seconds {
        case 0...60:
            let text = "\(seconds) SECONDS AGO"
            return truncatePlural(for: text, time: seconds)
        case 60...3599:
            let minutes = seconds / 60
            let text = "\(minutes) MINUTES AGO"
            return truncatePlural(for: text, time: minutes)
        case 3600...86399:
            let hours = seconds / 3600
            let text = "\(hours) HOURS AGO"
            return truncatePlural(for: text, time: hours)
        default:
            let days = seconds / 86400
            let text = "\(days) DAYS AGO"
            return truncatePlural(for: text, time: days)
        }
    }
    
    private func truncatePlural(for text: String, time: Int) -> String {
        if time == 1 {
            return text.replacingOccurrences(of: "S", with: "")
        }
        return text
    }
    
}

//
//  OKTableViewSectionSupplementaryView.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/22/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import Foundation

public enum OKTableViewSectionSupplementaryView {
    case header
    case footer
    
    public var identifer: String {
        switch self {
        case .header:
            return "Header"
        case .footer:
            return "Footer"
        }
    }
    
}

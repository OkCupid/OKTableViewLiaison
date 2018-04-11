//
//  OKTableViewSectionSupplementaryViewDisplayOption.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum OKTableViewSectionSupplementaryViewDisplayOption {
    case none
    case header(registrationType: OKTableViewRegistrationType)
    case footer(registrationType: OKTableViewRegistrationType)
    case both(headerRegistrationType: OKTableViewRegistrationType, footerRegistrationType: OKTableViewRegistrationType)
    
    public var headerRegistrationType: OKTableViewRegistrationType? {
        switch self {
        case .header(let registrationType), .both(let registrationType, _):
            return registrationType
        default:
            return nil
        }
    }
    
    public var footerRegistrationType: OKTableViewRegistrationType? {
        switch self {
        case .footer(let registrationType), .both(_, let registrationType):
            return registrationType
        default:
            return nil
        }
    }
}

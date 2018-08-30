//
//  OKTableViewSectionComponentDisplayOption.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum OKTableViewSectionComponentDisplayOption {
    case none
    case header(component: OKAnyTableViewSectionComponent)
    case footer(component: OKAnyTableViewSectionComponent)
    case both(headerComponent: OKAnyTableViewSectionComponent,
        footerComponent: OKAnyTableViewSectionComponent)
    
    func registerComponents(with registrar: OKTableViewRegistrar) {
        [header, footer].forEach {
            $0?.register(with: registrar)
        }
    }
    
    var header: OKAnyTableViewSectionComponent? {
        switch self {
        case .header(let header):
            return header
        case .both(let header, _):
            return header
        default:
            return nil
        }
    }
    
    var footer: OKAnyTableViewSectionComponent? {
        switch self {
        case .footer(let footer):
            return footer
        case .both(_, let footer):
            return footer
        default:
            return nil
        }
    }
}

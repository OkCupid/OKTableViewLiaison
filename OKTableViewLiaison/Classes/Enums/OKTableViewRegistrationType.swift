//
//  OKTableViewRegistrationType.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum OKTableViewRegistrationType<T> {
    case nib(nib: UINib, identifier: String)
    case `class`(identifier: String)
    
    public static var defaultClassType: OKTableViewRegistrationType {
        return .class(identifier: String(describing: T.self))
    }
    
    public static var defaultNibType: OKTableViewRegistrationType {
        return .nib(nib: UINib(nibName: String(describing: T.self), bundle: .main),
                    identifier: String(describing: T.self))
    }
    
    var identifier: String {
        switch self {
        case .class(let identifier), .nib(_, let identifier):
            return identifier
        }
    }
}

extension OKTableViewRegistrationType where T: UITableViewCell {
    var registration: OKTableViewRegistrar.Registration {
        return .cell(className: String(describing: T.self), identifier: identifier)
    }
}

extension OKTableViewRegistrationType where T: UITableViewHeaderFooterView {
    var registration: OKTableViewRegistrar.Registration {
        return .view(className: String(describing: T.self), identifier: identifier)
    }
}

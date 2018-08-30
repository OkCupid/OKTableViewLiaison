//
//  OKTableViewRegistrationType.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum OKTableViewRegistrationType<T: UIView> {
    case nib(nib: UINib, identifier: String)
    case `class`(identifier: String)
    
    public static var defaultClassType: OKTableViewRegistrationType {
        return .class(identifier: String(describing: T.self))
    }
    
    public static var defaultNibType: OKTableViewRegistrationType {
        return .nib(nib: T.nib,
                    identifier: String(describing: T.self))
    }
    
    var typeName: String {
        return String(describing: T.self)
    }
    
    var identifier: String {
        switch self {
        case .class(let identifier), .nib(_, let identifier):
            return identifier
        }
    }
}

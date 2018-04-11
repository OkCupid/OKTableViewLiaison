//
//  OKTableViewRegistrationType.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/21/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

public enum OKTableViewRegistrationType {
    case nib(nib: UINib, identifier: String)
    case `class`(identifier: String)
    
    public static func defaultClassRegistration<T: UIView>(for view: T.Type) -> OKTableViewRegistrationType {
        return OKTableViewRegistrationType.class(identifier: String(describing: view.self))
    }
    
    public static func defaultNibRegistration<T: UIView>(for view: T.Type) -> OKTableViewRegistrationType {
        return OKTableViewRegistrationType.nib(nib: view.nib,
                                             identifier: String(describing: view.self))
    }
    
    public var identifier: String {
        switch self {
        case .class(let identifier), .nib(_, let identifier):
            return identifier
        }
    }
}

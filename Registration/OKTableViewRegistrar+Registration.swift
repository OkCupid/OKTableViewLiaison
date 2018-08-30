//
//  OKTableViewRegistrar+Registration.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/30/18.
//

import Foundation

extension OKTableViewRegistrar {
    struct Registration: Hashable {
        let className: String
        let identifier: String
        
        init(className: String, identifier: String) {
            self.className = className
            self.identifier = identifier
        }
        
        init<T>(registrationType: OKTableViewRegistrationType<T>) {
            className = registrationType.className
            identifier = registrationType.identifier
        }
    }
}

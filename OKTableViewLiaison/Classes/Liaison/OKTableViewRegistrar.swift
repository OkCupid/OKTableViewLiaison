//
//  OKTableViewRegistrar.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/29/18.
//

import UIKit

public final class OKTableViewRegistrar {
    
    private enum Registration: Hashable {
        case view(typeName: String, identifier: String)
        case cell(typeName: String, identifier: String)
    }
    
    private var registrations = Set<Registration>()
    
    weak var tableView: UITableView? {
        didSet {
            registrations.removeAll()
        }
    }
    
    func registerView<T: UITableViewHeaderFooterView>(registrationType: OKTableViewRegistrationType<T>) {
        let registration: Registration = .view(typeName: registrationType.typeName,
                                               identifier: registrationType.identifier)
        
        guard !registrations.contains(registration) else { return }
        
        registrations.insert(registration)

        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    func registerCell<T: UITableViewCell>(registrationType: OKTableViewRegistrationType<T>) {
        let registration: Registration = .cell(typeName: registrationType.typeName,
                                               identifier: registrationType.identifier)
        
        guard !registrations.contains(registration) else { return }
        
        registrations.insert(registration)

        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forCellReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func register(section: OKTableViewSection) {

        section.componentDisplayOption.registerComponents(with: self)

        section.rows.forEach {
            $0.register(with: self)
        }
    }
    
    func register(sections: [OKTableViewSection]) {
        sections.forEach(register(section:))
    }
    
    func register(row: OKAnyTableViewRow) {
        row.register(with: self)
    }
    
    func register(rows: [OKAnyTableViewRow]) {
        rows.forEach(register(row:))
    }
}

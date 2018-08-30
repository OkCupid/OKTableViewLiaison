//
//  OKTableViewRegistrar.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/29/18.
//

import UIKit

public final class OKTableViewRegistrar {
    
    struct Registration: Hashable {
        let type: String
        let identifier: String
    }
    
    internal(set) var registrations = Set<Registration>()

    weak var tableView: UITableView? {
        didSet {
            registrations.removeAll()
        }
    }
    
    private func shouldUpdateRegistrations(type: String, identifier: String) -> Bool {
        let registration = Registration(type: type,
                                        identifier: identifier)
        
        guard !registrations.contains(registration) else { return false }
        
        if let existingRegistration = registrations.first(where: { $0.identifier == registration.identifier }) {
            registrations.remove(existingRegistration)
        }
        
        registrations.insert(registration)
        
        return true
    }
    
    func registerCell<T: UITableViewCell>(registrationType: OKTableViewRegistrationType<T>) {
        
        guard shouldUpdateRegistrations(type: registrationType.typeName,
                                        identifier: registrationType.identifier) else { return }
            
        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forCellReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func registerView<T: UITableViewHeaderFooterView>(registrationType: OKTableViewRegistrationType<T>) {
        
        guard shouldUpdateRegistrations(type: registrationType.typeName,
                                        identifier: registrationType.identifier) else { return }

        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
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

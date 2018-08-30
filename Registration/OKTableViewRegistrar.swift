//
//  OKTableViewRegistrar.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/29/18.
//

import UIKit

public final class OKTableViewRegistrar {
    
    private(set) var registrations = Set<Registration>()
    
    weak var tableView: UITableView? {
        didSet { registrations.removeAll() }
    }

    func registerIfNeeded<T>(registrationType: OKTableViewRegistrationType<T>) where T: UITableViewCell {
        
        guard shouldUpdateRegistrations(registrationType.registration) else { return }
        
        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forCellReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func registerIfNeeded<T>(registrationType: OKTableViewRegistrationType<T>) where T: UITableViewHeaderFooterView {
        
        guard shouldUpdateRegistrations(registrationType.registration) else { return }
        
        switch registrationType {
        case let .class(identifier):
            tableView?.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    private func shouldUpdateRegistrations(_ registration: Registration) -> Bool {
        if registrations.contains(registration) { return false }
        
        if let existingRegistration = registrations.first(where: { registration.hasSameIdentifier($0) }) {
            registrations.remove(existingRegistration)
        }
        
        registrations.insert(registration)
        
        return true
    }
    
    func register(section: OKTableViewSection) {
        guard tableView != nil else { return }
        
        section.componentDisplayOption.header?.register(with: self)
        section.componentDisplayOption.footer?.register(with: self)

        section.rows.forEach {
            $0.register(with: self)
        }
    }
    
    func register(sections: [OKTableViewSection]) {
        guard tableView != nil else { return }

        sections.forEach(register(section:))
    }
    
    func register(row: OKAnyTableViewRow) {
        guard tableView != nil else { return }

        row.register(with: self)
    }
    
    func register(rows: [OKAnyTableViewRow]) {
        guard tableView != nil else { return }

        rows.forEach(register(row:))
    }
}

//
//  OKTableViewRegistrar.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/29/18.
//

import UIKit

public final class OKTableViewRegistrar {
    
    var registrations: Set<Registration> {
        return _registrations.values.reduce(Set<Registration>()) { memo, set -> Set<Registration> in
            memo.union(set)
        }
    }
    
    weak var tableView: UITableView? {
        didSet {
            _registrations = [.cell: Set<Registration>(),
                              .view: Set<Registration>()]
        }
    }
    
    private var _registrations: [OKTableViewContentType: Set<Registration>] = [.cell: Set<Registration>(),
                                                                               .view: Set<Registration>()]

    func registerIfNeeded<T: UIView>(registrationType: OKTableViewRegistrationType<T>, contentType: OKTableViewContentType) {
        
        let registration = Registration(registrationType: registrationType)
        
        if _registrations[contentType]?.contains(registration) == true { return }
        
        if let existingRegistration = _registrations[contentType]?.first(where: { $0.identifier == registration.identifier }) {
            _registrations[contentType]?.remove(existingRegistration)
        }
        
        _registrations[contentType]?.insert(registration)
        
        switch (contentType, registrationType) {
        case let (.cell, .class(identifier)):
            tableView?.register(T.self, forCellReuseIdentifier: identifier)
        case let (.cell, .nib(nib, identifier)):
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        case let (.view, .class(identifier)):
            tableView?.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
        case let (.view, .nib(nib, identifier)):
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
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

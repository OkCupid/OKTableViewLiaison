//
//  OKTableViewLiaison+Registration.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/30/18.
//

import Foundation

extension OKTableViewLiaison {
    
    func register(section: OKTableViewSection) {
        guard let tableView = tableView else { return }
        
        section.componentDisplayOption.header?.register(with: tableView)
        section.componentDisplayOption.footer?.register(with: tableView)
        
        section.rows.forEach {
            $0.register(with: tableView)
        }
    }
    
    func register(sections: [OKTableViewSection]) {
        sections.forEach(register(section:))
    }
    
    func register(row: OKAnyTableViewRow) {
        guard let tableView = tableView else { return }
        row.register(with: tableView)
    }
    
    func register(rows: [OKAnyTableViewRow]) {
        rows.forEach(register(row:))
    }
}

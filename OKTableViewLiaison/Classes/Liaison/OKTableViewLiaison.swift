//
//  OKTableViewLiaison.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

final public class OKTableViewLiaison: NSObject {
    
    weak var tableView: UITableView? {
        didSet {
            registrar.tableView = tableView
            registrar.register(section: paginationSection)
            registrar.register(sections: sections)
        }
    }
    
    public internal(set) var sections = [OKTableViewSection]()
    
    public weak var paginationDelegate: OKTableViewLiaisonPaginationDelegate?
    
    let paginationSection: OKTableViewSection
    
    var waitingForPaginatedResults = false
    
    let registrar = OKTableViewRegistrar()

    public init(sections: [OKTableViewSection] = [],
                paginationRow: OKAnyTableViewRow? = nil) {
        self.sections = sections
        self.paginationSection = OKTableViewSection(rows: [paginationRow ?? OKPaginationTableViewRow()])
        super.init()
    }
    
    public func liaise(tableView: UITableView) {
        self.tableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
    }
    
    public func detach() {
        tableView?.delegate = nil
        tableView?.dataSource = nil
        
        if #available(iOS 10.0, *) {
            tableView?.prefetchDataSource = nil
        }
        
        tableView = nil
    }
    
    public func reloadData() {
        tableView?.reloadData()
    }
    
    public func reloadVisibleRows() {
        guard let indexPaths = tableView?.indexPathsForVisibleRows else { return }
        
        reloadRows(at: indexPaths)
    }
    
    public func scroll(to indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition = .none, animated: Bool = true) {
        guard row(for: indexPath) != nil else { return }
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }

    public func toggleIsEditing() {
        guard let tv = tableView else { return }
        
        tv.isEditing = !tv.isEditing
    }
    
    func row(for indexPath: IndexPath) -> OKAnyTableViewRow? {
        guard let section = sections.element(at: indexPath.section) else { return nil }
        
        return section.rows.element(at: indexPath.row)
    }
    
    func performTableViewUpdates(animated: Bool, _ closure: () -> Void) {
        if animated {
            tableView?.beginUpdates()
            closure()
            tableView?.endUpdates()
        } else {
            reloadData()
        }
    }
}

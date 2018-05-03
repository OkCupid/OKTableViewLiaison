//
//  OKTableViewLiaison.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

final public class OKTableViewLiaison: NSObject {
    weak var tableView: UITableView?
    public internal(set) var sections = [OKAnyTableViewSection]()
    
    let paginationSection: OKPaginationTableViewSection
    var waitingForPaginatedResults = false
    public weak var paginationDelegate: OKTableViewLiaisonPaginationDelegate?

    public init(sections: [OKAnyTableViewSection] = [],
                paginationRow: OKAnyTableViewRow = OKPaginationTableViewRow()) {
        self.sections = sections
        self.paginationSection = OKPaginationTableViewSection(row: paginationRow)
        super.init()
    }
    
    public func liaise(tableView: UITableView) {
        self.tableView = tableView
        
        sections.forEach {
            $0.tableView = tableView
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func detachTableView() {
        tableView?.delegate = nil
        tableView?.dataSource = nil
        tableView = nil
    }
    
    public func reloadData() {
        tableView?.reloadData()
    }
    
    public func reloadVisibleRows() {
        guard let indexPaths = tableView?.indexPathsForVisibleRows else {
            return
        }
        
        reloadRows(at: indexPaths)
    }
    
    public func scroll(to indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition = .none, animated: Bool = true) {
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }

    public func toggleIsEditing() {
        guard let tv = tableView else {
            return
        }
        
        tv.isEditing = !tv.isEditing
    }
    
    func section(for indexPath: IndexPath) -> OKAnyTableViewSection? {
        return sections.element(at: indexPath.section)
    }
    
    func row(for indexPath: IndexPath) -> OKAnyTableViewRow? {
        
        guard let section = section(for: indexPath) else {
            return nil
        }
        
        return section.rows.element(at: indexPath.row)
    }
    
    func registerCell(for row: OKAnyTableViewRow) {
        guard let tableView = tableView else {
            return
        }

        row.registerCellType(with: tableView)
    }
    
    func performTableViewUpdates(animated: Bool = true, _ closure: () -> Void) {
        
        if animated {
            tableView?.beginUpdates()
            closure()
            tableView?.endUpdates()
        } else {
            reloadData()
        }
    }
}

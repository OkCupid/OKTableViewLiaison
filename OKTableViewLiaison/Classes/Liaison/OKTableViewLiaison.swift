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
        didSet { syncSections() }
    }
    
    public internal(set) var sections = [OKTableViewSection]() {
        didSet { syncSections() }
    }
    
    let paginationSection: OKPaginationTableViewSection
    var waitingForPaginatedResults = false
    public weak var paginationDelegate: OKTableViewLiaisonPaginationDelegate?

    public init(sections: [OKTableViewSection] = [],
                paginationRow: OKAnyTableViewRow = OKPaginationTableViewRow()) {
        self.sections = sections
        self.paginationSection = OKPaginationTableViewSection(row: paginationRow)
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
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }

    public func toggleIsEditing() {
        guard let tv = tableView else { return }
        
        tv.isEditing = !tv.isEditing
    }
    
    public func section(for index: Int) -> OKTableViewSection? {
        return sections.element(at: index)
    }
    
    public func section(for indexPath: IndexPath) -> OKTableViewSection? {
        return sections.element(at: indexPath.section)
    }
    
    public func row(for indexPath: IndexPath) -> OKAnyTableViewRow? {
        guard let section = section(for: indexPath) else { return nil }
        
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
    
    private func syncSections() {
        sections.forEach {
            if $0.tableView != tableView {
                $0.tableView = tableView
            }
        }
    }
}

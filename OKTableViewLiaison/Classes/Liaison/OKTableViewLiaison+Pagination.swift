//
//  OKTableViewLiaison+Pagination.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

extension OKTableViewLiaison {
    
    private var lastIndexPath: IndexPath? {
        guard let lastSection = sections.last,
            !lastSection.rows.isEmpty else {
                return nil
        }
        
        let row = lastSection.rows.lastIndex
        let section = sections.lastIndex
        
        return IndexPath(row: row, section: section)
    }
    
    func showPaginationSpinner(after indexPath: IndexPath) {
        if paginationDelegate?.isPaginationEnabled() == true && indexPath == lastIndexPath {
            
            if !waitingForPaginatedResults {
                waitingForPaginatedResults = true

                let paginationIndexPath = IndexPath(row: 0, section: sections.count)
                // UITableViewDelegate tableView(_:willDisplay:forRowAt:) is executed on background thread
                DispatchQueue.main.async {
                    self.addPaginationSection()
                    self.paginationDelegate?.paginationStarted(indexPath: paginationIndexPath)
                }
            }
        }
    }
    
    func removePaginationSpinner(animated: Bool) {
        guard waitingForPaginatedResults else { return }
        waitingForPaginatedResults = false
    
        deleteSection(at: sections.lastIndex, animation: .none, animated: animated)
    }
    
    func endPagination(rows: [OKAnyTableViewRow], to section: Int, animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        removePaginationSpinner(animated: rows.isEmpty)
        
        guard !rows.isEmpty,
            let lastSection = sections.last else { return }
        
        let firstNewIndexPath = IndexPath(row: lastSection.rows.count, section: sections.lastIndex)

        append(rows: rows, to: section, animation: animation, animated: animated)
        paginationDelegate?.paginationEnded(indexPath: firstNewIndexPath)
    }
    
    func endPagination(sections: [OKTableViewSection], animation: UITableView.RowAnimation = .automatic, animated: Bool = true) {
        removePaginationSpinner(animated: sections.isEmpty)
        
        guard !sections.isEmpty else { return }
        let firstNewIndexPath = IndexPath(row: 0, section: self.sections.count)
        append(sections: sections, animation: animation, animated: animated)
        paginationDelegate?.paginationEnded(indexPath: firstNewIndexPath)
    }

    private func addPaginationSection() {
        let indexSet = IndexSet(integer: sections.count)
        sections.append(paginationSection)
        performTableViewUpdates(animated: true) {
            tableView?.insertSections(indexSet, with: .none)
        }
    }
}

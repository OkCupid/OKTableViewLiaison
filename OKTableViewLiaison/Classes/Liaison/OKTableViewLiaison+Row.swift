//
//  OKTableViewLiaison+Row.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

public extension OKTableViewLiaison {
    
    public func append(rows: [OKAnyTableViewRow], to section: Int = 0, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        if waitingForPaginatedResults {
            endPagination(rows: rows)
            return
        }
        
        guard sections.indices.contains(section),
            !rows.isEmpty else { return }
        
        var lastRowIndex = sections[section].rows.count - 1
                
        sections[section].append(rows: rows)
        register(rows: rows)
        
        let indexPaths = rows.map { row -> IndexPath in
            lastRowIndex += 1
            return IndexPath(row: lastRowIndex, section: section)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: indexPaths, with: animation)
        }
        
        zip(rows, indexPaths).forEach { row, indexPath in
            if let cell = tableView?.cellForRow(at: indexPath) {
                row.perform(command: .insert, for: cell, at: indexPath)
            }
        }
        
    }
    
    public func append(row: OKAnyTableViewRow, to section: Int = 0, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        append(rows: [row], to: section, animation: animation, animated: animated)
    }
    
    public func insert(row: OKAnyTableViewRow, at indexPath: IndexPath, with animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(indexPath.section) else { return }
        
        sections[indexPath.section].insert(row: row, at: indexPath)
        register(row: row)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        if let cell = tableView?.cellForRow(at: indexPath) {
            row.perform(command: .insert, for: cell, at: indexPath)
        }
    }
    
    @discardableResult
    public func deleteRows(at indexPaths: [IndexPath], animation: UITableViewRowAnimation = .automatic, animated: Bool = true) -> [OKAnyTableViewRow] {
        
        guard !indexPaths.isEmpty else { return [] }
        
        let sortedIndexPaths = indexPaths.sortBySection()
        var deletedRows = [OKAnyTableViewRow]()
        
        sortedIndexPaths.forEach { section, indexPaths in
            if sections.indices.contains(section) {
                
                indexPaths.forEach {
                    
                    if let row = sections[section].deleteRow(at: $0) {
                        deletedRows.append(row)
                        
                        if let cell = tableView?.cellForRow(at: $0) {
                            row.perform(command: .delete, for: cell, at: $0)
                        }
                    }
                }
                
                performTableViewUpdates(animated: animated) {
                    tableView?.deleteRows(at: indexPaths, with: animation)
                }
            }
        }
        
        return deletedRows
        
    }
    
    @discardableResult
    public func deleteRow(at indexPath: IndexPath, with animation: UITableViewRowAnimation = .automatic, animated: Bool = true) -> OKAnyTableViewRow? {
        
        guard sections.indices.contains(indexPath.section) else { return nil }
        
        let row = sections[indexPath.section].deleteRow(at: indexPath)
        
        if let cell = tableView?.cellForRow(at: indexPath) {
            row?.perform(command: .delete, for: cell, at: indexPath)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
        }
        
        return row
    }
    
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation = .automatic) {
        tableView?.beginUpdates()
        tableView?.reloadRows(at: indexPaths, with: animation)
        tableView?.endUpdates()
        
        indexPaths.forEach {
            if let cell = tableView?.cellForRow(at: $0) {
                row(for: $0)?.perform(command: .reload, for: cell, at: $0)
            }
        }
    }
    
    public func reloadRow(at indexPath: IndexPath, with animation: UITableViewRowAnimation = .automatic) {
        reloadRows(at: [indexPath], with: animation)
    }
    
    public func replaceRow(at indexPath: IndexPath, with row: OKAnyTableViewRow, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(indexPath.section) else { return }
        
        let deletedRow = sections[indexPath.section].deleteRow(at: indexPath)
        if let cell = tableView?.cellForRow(at: indexPath) {
            deletedRow?.perform(command: .delete, for: cell, at: indexPath)
        }
        
        sections[indexPath.section].insert(row: row, at: indexPath)
        register(row: row)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        if let cell = tableView?.cellForRow(at: indexPath) {
            row.perform(command: .insert, for: cell, at: indexPath)
        }
    }
    
    public func moveRow(from source: IndexPath, to destination: IndexPath, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        let indices = sections.indices
        guard indices.contains(source.section) && indices.contains(destination.section) else { return }
        
        guard let row = sections[source.section].deleteRow(at: source) else {
            return
        }
        
        sections[destination.section].insert(row: row, at: destination)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveRow(at: source, to: destination)
        }
        
        if let cell = tableView?.cellForRow(at: destination) {
            row.perform(command: .move, for: cell, at: destination)
        }
    }
    
    public func swapRow(at source: IndexPath, with destination: IndexPath, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        let indices = sections.indices
        guard indices.contains(source.section) && indices.contains(destination.section) else { return }
        
        if source.section == destination.section {
            sections[source.section].swapRows(at: source, to: destination)
        } else {

            
            guard let sourceRow = sections[source.section].deleteRow(at: source),
                let destinationRow = sections[destination.section].deleteRow(at: destination) else { return }
            
            sections[source.section].insert(row: destinationRow, at: source)
            sections[destination.section].insert(row: sourceRow, at: destination)
        }
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveRow(at: source, to: destination)
            tableView?.moveRow(at: destination, to: source)
        }
        
        if let sourceCell = tableView?.cellForRow(at: source) {
            row(for: source)?.perform(command: .move, for: sourceCell, at: source)
        }
        
        if let destinationCell = tableView?.cellForRow(at: destination) {
            row(for: destination)?.perform(command: .move, for: destinationCell, at: destination)
        }
    }
}

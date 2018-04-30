//
//  OKTableViewLiaison+Row.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

public extension OKTableViewLiaison {
    
    public func append(rows: [OKAnyTableViewRow], to section: Int = 0, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        if isShowingPaginationSpinner {
            endPagination(rows: rows)
            return
        }
        
        guard let _section = sections.element(at: section),
            !rows.isEmpty else {
                return
        }
        
        rows.forEach {
            registerCell(for: $0)
        }
        
        var lastRowIndex = _section.rows.count - 1
        
        _section.append(rows: rows)
        
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
        
        guard let section = section(for: indexPath) else {
            return
        }
        
        registerCell(for: row)
        
        section.insert(row: row, at: indexPath)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        if let cell = tableView?.cellForRow(at: indexPath) {
            row.perform(command: .insert, for: cell, at: indexPath)
        }
        
    }
    
    @discardableResult
    public func deleteRows(at indexPaths: [IndexPath], animation: UITableViewRowAnimation = .automatic, animated: Bool = true) -> [OKAnyTableViewRow] {
        
        guard !indexPaths.isEmpty else {
            return []
        }
        
        let sortedIndexPaths = indexPaths.sortBySection()
        var deletedRows = [OKAnyTableViewRow]()
        
        sortedIndexPaths.forEach { (section, indexPaths) in
            if let section = sections.element(at: section) {
                
                indexPaths.forEach {
                    
                    if let row = section.deleteRow(at: $0) {
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
        
        let row = section(for: indexPath)?.deleteRow(at: indexPath)
        
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
    
    public func replaceRow(at indexPath: IndexPath, with row: OKAnyTableViewRow, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard let section = section(for: indexPath) else {
            return
        }
        
        let deletedRow = section.deleteRow(at: indexPath)
        if let cell = tableView?.cellForRow(at: indexPath) {
            deletedRow?.perform(command: .delete, for: cell, at: indexPath)
        }
        
        registerCell(for: row)
        section.insert(row: row, at: indexPath)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
            tableView?.insertRows(at: [indexPath], with: animation)
        }
        
        if let cell = tableView?.cellForRow(at: indexPath) {
            row.perform(command: .insert, for: cell, at: indexPath)
        }
    }
    
    public func moveRow(from source: IndexPath, to destination: IndexPath, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard let sourceSection = section(for: source),
            let destinationSection = section(for: destination) else {
                return
        }
        
        guard let row = sourceSection.deleteRow(at: source) else {
            return
        }
        
        destinationSection.insert(row: row, at: destination)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveRow(at: source, to: destination)
        }
        
        if let cell = tableView?.cellForRow(at: destination) {
            row.perform(command: .move, for: cell, at: destination)
        }
    }
    
    public func swapRow(from source: IndexPath, to destination: IndexPath, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        if source.section == destination.section {
            section(for: source)?.swapRows(at: source, to: destination)
        } else {
            guard let sourceSection = section(for: source),
                let destinationSection = section(for: destination) else {
                    return
            }
            
            guard let sourceRow = sourceSection.deleteRow(at: source),
                let destinationRow = destinationSection.deleteRow(at: destination) else {
                    return
            }
            
            sourceSection.insert(row: destinationRow, at: source)
            destinationSection.insert(row: sourceRow, at: destination)
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

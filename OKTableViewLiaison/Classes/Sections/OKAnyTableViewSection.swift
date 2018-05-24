//
//  OKAnyTableViewSection.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/28/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

open class OKAnyTableViewSection {
    weak var tableView: UITableView?
    public private(set) var rows: [OKAnyTableViewRow]

    init(rows: [OKAnyTableViewRow] = []) {
        self.rows = rows
    }
    
    public func perform(command: OKTableViewSectionCommand, supplementaryView: OKTableViewSectionSupplementaryView, for view: UIView, in section: Int) {
        fatalError("OKAnyTableViewSection is an abstract class. Please use a valid subclass and override \(#function)")
    }
    
    public func calculateHeight(for supplementaryView: OKTableViewSectionSupplementaryView) -> CGFloat {
        fatalError("OKAnyTableViewSection is an abstract class. Please use a valid subclass and override \(#function)")
    }

    public func view(supplementaryView: OKTableViewSectionSupplementaryView, for tableView: UITableView, in section: Int) -> UIView? {
        fatalError("OKAnyTableViewSection is an abstract class. Please use a valid subclass and override \(#function)")
    }
    
    // MARK: - Helpers
    func rowIndexPaths(for section: Int) -> [IndexPath] {
        return rows.enumerated().map { item, _ -> IndexPath in
            return IndexPath(item: item, section: section)
        }
    }
    
    func append(row: OKAnyTableViewRow) {
        registerCell(for: row)
        rows.append(row)
    }
    
    func append(rows: [OKAnyTableViewRow]) {
        rows.forEach(registerCell(for:))
        self.rows.append(contentsOf: rows)
    }
    
    @discardableResult
    func deleteRow(at indexPath: IndexPath) -> OKAnyTableViewRow? {
        guard rows.indices.contains(indexPath.item) else { return nil }
        
        return rows.remove(at: indexPath.item)
    }
    
    func insert(row: OKAnyTableViewRow, at indexPath: IndexPath) {
        guard rows.count >= indexPath.item else { return }
        
        registerCell(for: row)
        rows.insert(row, at: indexPath.item)
    }
    
    func swapRows(at source: IndexPath, to destination: IndexPath) {
        guard rows.indices.contains(source.item) && rows.indices.contains(destination.item) else { return }
        
        rows.swapAt(source.item, destination.item)
    }
    
    func removeAllRows() {
        rows.removeAll()
    }
    
    private func registerCell(for row: OKAnyTableViewRow) {
        guard let tableView = tableView else { return }
        
        row.registerCellType(with: tableView)
    }
}

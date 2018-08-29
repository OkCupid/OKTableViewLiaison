//
//  OKTableViewSection.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/28/18.
//

import Foundation

public struct OKTableViewSection {
    
    private weak var tableView: UITableView? {
        didSet {
            registerRowCells()
            registerComponentViews()
        }
    }
    
    public internal(set) var rows: [OKAnyTableViewRow]
    
    public let componentDisplayOption: OKTableViewSectionComponentDisplayOption
    
    public init(rows: [OKAnyTableViewRow] = [],
         componentDisplayOption: OKTableViewSectionComponentDisplayOption = .none) {
        self.rows = rows
        self.componentDisplayOption = componentDisplayOption
    }
    
    mutating func sync(tableView: UITableView?) {
        if self.tableView != tableView {
            self.tableView = tableView
        }
    }
    
    public func perform(command: OKTableViewSectionComponentCommand, componentView: OKTableViewSectionComponentView, for view: UIView, in section: Int) {
        switch componentView {
        case .header:
            componentDisplayOption.header?.perform(command: command, for: view, in: section)
        case .footer:
            componentDisplayOption.footer?.perform(command: command, for: view, in: section)
        }
    }
    
    public func view(componentView: OKTableViewSectionComponentView, for tableView: UITableView, in section: Int) -> UIView? {
        switch componentView {
        case .header:
            return componentDisplayOption.header?.view(for: tableView, in: section)
        case .footer:
            return componentDisplayOption.footer?.view(for: tableView, in: section)
        }
    }
    
    func calculate(height: OKTableViewHeightType, for componentView: OKTableViewSectionComponentView) -> CGFloat {
        
        switch (componentDisplayOption, componentView) {
        case (.both(let header, _), .header):
            return header.calculate(height: height)
        case (.both(_, let footer), .footer):
            return footer.calculate(height: height)
        case (.header(let header), .header):
            return header.calculate(height: height)
        case (.footer(let footer), .footer):
            return footer.calculate(height: height)
        default:
            if #available(iOS 11.0, *) {
                return .leastNormalMagnitude
            } else {
                return 0
            }
        }
    }
    
    // MARK: - Helpers
    func rowIndexPaths(for section: Int) -> [IndexPath] {
        return rows.enumerated().map { item, _ -> IndexPath in
            return IndexPath(item: item, section: section)
        }
    }
    
    // MARK: - Type Registration
    private func registerCell(for row: OKAnyTableViewRow) {
        guard let tableView = tableView else { return }
        
        row.registerCellType(with: tableView)
    }
    
    private func registerRowCells() {
        guard let tableView = tableView else { return }
        
        rows.forEach {
            $0.registerCellType(with: tableView)
        }
    }
    
    private func registerComponentViews() {
        guard let tableView = tableView else { return }
        componentDisplayOption.registerComponentViews(with: tableView)
    }
    
    // MARK: - Helpers
    mutating func append(row: OKAnyTableViewRow) {
        registerCell(for: row)
        rows.append(row)
    }
    
    mutating func append(rows: [OKAnyTableViewRow]) {
        rows.forEach(registerCell(for:))
        self.rows.append(contentsOf: rows)
    }
    
    @discardableResult
    mutating func deleteRow(at indexPath: IndexPath) -> OKAnyTableViewRow? {
        guard rows.indices.contains(indexPath.item) else { return nil }
        
        return rows.remove(at: indexPath.item)
    }
    
    mutating func insert(row: OKAnyTableViewRow, at indexPath: IndexPath) {
        guard rows.count >= indexPath.item else { return }
        
        registerCell(for: row)
        rows.insert(row, at: indexPath.item)
    }
    
    mutating func swapRows(at source: IndexPath, to destination: IndexPath) {
        guard rows.indices.contains(source.item) && rows.indices.contains(destination.item) else { return }
        
        rows.swapAt(source.item, destination.item)
    }
    
    mutating func removeAllRows() {
        rows.removeAll()
    }
}

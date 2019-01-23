//
//  OKTableViewSection.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 8/28/18.
//

import UIKit

public struct OKTableViewSection {
    
    public internal(set) var rows: [OKAnyTableViewRow]
    
    public let componentDisplayOption: OKTableViewSectionComponentDisplayOption
    
    public init(rows: [OKAnyTableViewRow] = [],
                componentDisplayOption: OKTableViewSectionComponentDisplayOption = .none) {
        self.rows = rows
        self.componentDisplayOption = componentDisplayOption
    }
    
    func perform(command: OKTableViewSectionComponentCommand, componentView: OKTableViewSectionComponentView, for view: UIView, in section: Int) {
        switch componentView {
        case .header:
            componentDisplayOption.header?.perform(command: command, for: view, in: section)
        case .footer:
            componentDisplayOption.footer?.perform(command: command, for: view, in: section)
        }
    }
    
    func view(componentView: OKTableViewSectionComponentView, for tableView: UITableView, in section: Int) -> UIView? {
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
            return calculate(height, for: header)
        case (.both(_, let footer), .footer):
            return calculate(height, for: footer)
        case (.header(let header), .header):
            return calculate(height, for: header)
        case (.footer(let footer), .footer):
            return calculate(height, for: footer)
        default:
            if #available(iOS 11.0, *) {
                return .leastNormalMagnitude
            } else {
                return 0
            }
        }
    }
    
    private func calculate(_ height: OKTableViewHeightType, for sectionComponent: OKAnyTableViewSectionComponent) -> CGFloat {
        switch height {
        case .height:
            return sectionComponent.height
        case .estimatedHeight:
            return sectionComponent.estimatedHeight
        }
    }
    
    // MARK: - Helpers
    func rowIndexPaths(for section: Int) -> [IndexPath] {
        return rows.enumerated().map { item, _ -> IndexPath in
            return IndexPath(item: item, section: section)
        }
    }
    
    // MARK: - Helpers
    mutating func append(row: OKAnyTableViewRow) {
        rows.append(row)
    }
    
    mutating func append(rows: [OKAnyTableViewRow]) {
        self.rows.append(contentsOf: rows)
    }
    
    @discardableResult
    mutating func deleteRow(at indexPath: IndexPath) -> OKAnyTableViewRow? {
        guard rows.indices.contains(indexPath.item) else { return nil }
        return rows.remove(at: indexPath.item)
    }
    
    mutating func insert(row: OKAnyTableViewRow, at indexPath: IndexPath) {
        guard rows.count >= indexPath.item else { return }
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

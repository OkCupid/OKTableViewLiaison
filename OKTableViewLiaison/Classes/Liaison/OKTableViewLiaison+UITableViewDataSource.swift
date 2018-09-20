//
//  OKTableViewLiaison+UITableViewDataSource.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

extension OKTableViewLiaison: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.element(at: section)?.rows.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = row(for: indexPath)?.cell(for: tableView, at: indexPath) else {
            fatalError("Row does not exist for indexPath: \(indexPath)")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.editable ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.movable ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let row = row(for: indexPath) else { return }
            deleteRow(at: indexPath, with: row.deleteRowAnimation)
        case .insert:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            row(for: indexPath)?.perform(command: .insert, for: cell, at: indexPath)
        case .none:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: sourceIndexPath) else { return }
        
        row(for: sourceIndexPath)?.perform(command: .move, for: cell, at: destinationIndexPath)
        moveRow(from: sourceIndexPath, to: destinationIndexPath)
    }
}

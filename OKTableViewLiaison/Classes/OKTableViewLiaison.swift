//
//  OKTableViewLiaison.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

final public class OKTableViewLiaison: NSObject {
    private weak var tableView: UITableView?
    public private(set) var sections = [OKAnyTableViewSection]()
    
    private let paginationSection: OKPaginationTableViewSection
    private var waitingForPaginatedResults = false
    public weak var paginationDelegate: OKTableViewLiaisonPaginationDelegate?

    public init(paginationRow: OKAnyTableViewRow = OKPaginationTableViewRow()) {
        self.paginationSection = OKPaginationTableViewSection(row: paginationRow)
        super.init()
    }
    
    public func liaise(tableView: UITableView) {
        self.tableView = tableView
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
    
    private func section(for indexPath: IndexPath) -> OKAnyTableViewSection? {
        return sections.element(at: indexPath.section)
    }
    
    private func row(for indexPath: IndexPath) -> OKAnyTableViewRow? {
        
        guard let section = section(for: indexPath) else {
            return nil
        }
        
        return section.rows.element(at: indexPath.row)
    }
    
    private func registerCell(for row: OKAnyTableViewRow) {
        guard let tableView = tableView else {
            return
        }

        row.registerCellType(with: tableView)
    }
    
    private func performTableViewUpdates(animated: Bool = true, _ closure: () -> Void) {
        
        if animated {
            tableView?.beginUpdates()
            closure()
            tableView?.endUpdates()
        } else {
            reloadData()
        }
    }
    
}

// MARK: - Section
public extension OKTableViewLiaison {
    
    public func append(sections: [OKAnyTableViewSection], animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        if isShowingPaginationSpinner {
            endPagination(sections: sections)
            return
        }
        
        guard !sections.isEmpty else {
            return
        }
        
        sections.forEach {
            $0.tableView = tableView
        }
        
        let lowerBound = self.sections.count
        let upperBound = lowerBound + sections.count - 1
        let indexSet = IndexSet(integersIn: lowerBound...upperBound)
        self.sections.append(contentsOf: sections)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(indexSet, with: animation)
        }
        
    }
    
    public func append(section: OKAnyTableViewSection, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        append(sections: [section], animation: animation, animated: animated)
    }
    
    public func insert(section: OKAnyTableViewSection, at index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        section.tableView = tableView
        sections.insert(section, at: index)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(IndexSet(integer: index), with: animation)
        }
        
    }
    
    public func emptySection(at index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        guard let section = sections.element(at: index) else {
            return
        }
        
        let indexPaths = section.rowIndexPaths(for: index)
        section.removeAllRows()
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: indexPaths, with: animation)
        }

    }
    
    public func deleteSection(at index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        sections.remove(at: index)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(IndexSet(integer: index), with: animation)
        }
    }
    
    public func replaceSection(at index: Int, with section: OKAnyTableViewSection, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        sections.remove(at: index)
        section.tableView = tableView
        sections.insert(section, at: index)
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(IndexSet(integer: index), with: animation)
            tableView?.insertSections(IndexSet(integer: index), with: animation)
        }
    }
    
    public func reloadSection(at index: Int, with animation: UITableViewRowAnimation = .automatic) {
        tableView?.beginUpdates()
        tableView?.reloadSections(IndexSet(integer: index), with: animation)
        tableView?.endUpdates()
    }
    
    public func moveSection(at: Int, to: Int, with animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        let section = sections.remove(at: at)
        sections.insert(section, at: to)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveSection(at, toSection: to)
        }
    }
    
    public func clearSections(replacedBy sections: [OKAnyTableViewSection] = [],
                              animation: UITableViewRowAnimation = .automatic,
                              animated: Bool = true) {
        
        guard !self.sections.isEmpty else {
            return
        }
        
        let sectionsRange = 0...self.sections.count - 1
        let indexSet = IndexSet(integersIn: sectionsRange)
        
        self.sections.removeAll()
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(indexSet, with: animation)
        }
        
        append(sections: sections, animation: animation, animated: animated)
    }
}

// MARK: - Row
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
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
        }
        
        return row
    }
    
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation = .automatic) {
        tableView?.beginUpdates()
        tableView?.reloadRows(at: indexPaths, with: animation)
        tableView?.endUpdates()
    }
    
    public func replaceRow(at indexPath: IndexPath, with row: OKAnyTableViewRow, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard let section = section(for: indexPath) else {
            return
        }

        section.deleteRow(at: indexPath)
        registerCell(for: row)
        section.insert(row: row, at: indexPath)

        performTableViewUpdates(animated: animated) {
            tableView?.deleteRows(at: [indexPath], with: animation)
            tableView?.insertRows(at: [indexPath], with: animation)
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
    }
}

// MARK: - Pagination
public extension OKTableViewLiaison {
    
    private var lastIndexPath: IndexPath? {
        
        guard let lastSection = sections.last,
            !lastSection.rows.isEmpty else {
                return nil
        }
        
        let row = lastSection.rows.count - 1
        let section = sections.count - 1
        
        return IndexPath(row: row, section: section)
    }
    
    private func showPaginationSpinner(after indexPath: IndexPath) {
        if paginationDelegate?.isPaginationEnabled() == true && indexPath == lastIndexPath {
            
            if !isShowingPaginationSpinner {
                waitingForPaginatedResults = true

                let paginationIndexPath = IndexPath(row: 0, section: sections.count)
                // UITableViewDelegate tableView(_:willDisplay:forRowAt:) is executed on background thread
                DispatchQueue.main.async {
                    self.append(section: self.paginationSection)
                    self.paginationDelegate?.paginationStarted(indexPath: paginationIndexPath)
                }
            }
        }
    }
    
    private var isShowingPaginationSpinner: Bool {
        return (sections.last is OKPaginationTableViewSection && waitingForPaginatedResults)
    }
    
    private func hidePaginationSpinner(animated: Bool) {
        guard isShowingPaginationSpinner else { return }
        waitingForPaginatedResults = false

        if animated {
            deleteSection(at: sections.count - 1, animation: .none)
        } else {
            sections.remove(at: sections.count - 1)
        }
    }
    
    private func endPagination(rows: [OKAnyTableViewRow]) {
        hidePaginationSpinner(animated: rows.isEmpty)
        guard !rows.isEmpty,
            let lastSection = sections.last else { return }
        
        let firstNewIndexPath = IndexPath(row: lastSection.rows.count, section: sections.count - 1)
        lastSection.append(rows: rows)
        reloadData()
        paginationDelegate?.paginationEnded(indexPath: firstNewIndexPath)
    }
    
    private func endPagination(sections: [OKAnyTableViewSection]) {
        hidePaginationSpinner(animated: sections.isEmpty)
        guard !sections.isEmpty else { return }
        let firstNewIndexPath = IndexPath(row: 0, section: self.sections.count)
        self.sections.append(contentsOf: sections)
        reloadData()
        paginationDelegate?.paginationEnded(indexPath: firstNewIndexPath)
    }
}

extension OKTableViewLiaison: UITableViewDataSource {

    private func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = row(for: indexPath)?.cell(for: tableView, at: indexPath) else {
            fatalError("Row does not exist for indexPath: \(indexPath)")
        }
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.element(at: section)?.rows.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.editable ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.movable ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let cell = tableView.cellForRow(at: indexPath),
                let row = row(for: indexPath) else {
                return
            }
            
            row.perform(command: .delete, for: cell, at: indexPath)
            deleteRow(at: indexPath, with: row.deleteRowAnimation)
        case .insert:
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            row(for: indexPath)?.perform(command: .insert, for: cell, at: indexPath)
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: sourceIndexPath) else {
            return
        }
        
        row(for: sourceIndexPath)?.perform(command: .move, for: cell, at: destinationIndexPath)
        moveRow(from: sourceIndexPath, to: destinationIndexPath)
    }
    
}

extension OKTableViewLiaison: UITableViewDelegate {
    private func perform(command: OKTableViewRowCommand, for tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        row(for: indexPath)?.perform(command: command, for: cell, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        row(for: indexPath)?.perform(command: .willSelect, for: cell, at: indexPath)
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(command: .didSelect, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        row(for: indexPath)?.perform(command: .willDeselect, for: cell, at: indexPath)
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        perform(command: .didDeselect, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        moveRow(from: sourceIndexPath, to: proposedDestinationIndexPath)
        return proposedDestinationIndexPath
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        row(for: indexPath)?.perform(command: .willDisplay, for: cell, at: indexPath)
        showPaginationSpinner(after: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        row(for: indexPath)?.perform(command: .didEndDisplaying, for: cell, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        perform(command: .willBeginEditing, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        perform(command: .didEndEditing, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        perform(command: .didHighlight, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        perform(command: .didUnhighlight, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections.element(at: section)?.view(supplementaryView: .header, for: tableView, in: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections.element(at: section)?.view(supplementaryView: .footer, for: tableView, in: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return row(for: indexPath)?.height ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return row(for: indexPath)?.estimatedHeight ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.indentWhileEditing ?? false
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return row(for: indexPath)?.editingStyle ?? .none
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return row(for: indexPath)?.editActions
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        perform(command: .accessoryButtonTapped, for: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return row(for: indexPath)?.deleteConfirmationTitle
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculateHeight(for: .header) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculateHeight(for: .footer) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(command: .willDisplay, supplementaryView: .header, for: view, in: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(command: .willDisplay, supplementaryView: .footer, for: view, in: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(command: .didEndDisplaying, supplementaryView: .header, for: view, in: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(command: .didEndDisplaying, supplementaryView: .footer, for: view, in: section)
    }
    
}


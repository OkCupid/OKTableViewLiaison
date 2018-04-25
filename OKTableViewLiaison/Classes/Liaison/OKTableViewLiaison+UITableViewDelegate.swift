//
//  OKTableViewLiaison+UITableViewDelegate.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

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

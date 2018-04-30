//
//  OKTableViewLiaison+Section.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

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

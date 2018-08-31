//
//  OKTableViewLiaison+Section.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

public extension OKTableViewLiaison {
    
    public func append(sections: [OKTableViewSection], animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        if waitingForPaginatedResults {
            endPagination(sections: sections)
            return
        }
        
        guard !sections.isEmpty else { return }
        
        let lowerBound = self.sections.count
        let upperBound = lowerBound + sections.lastIndex
        let indexSet = IndexSet(integersIn: lowerBound...upperBound)
        
        self.sections.append(contentsOf: sections)
        register(sections: sections)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(indexSet, with: animation)
        }
        
    }
    
    public func append(section: OKTableViewSection, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        append(sections: [section], animation: animation, animated: animated)
    }
    
    public func insert(sections: [OKTableViewSection], startingAt index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        guard !sections.isEmpty else { return }

        let indexRange = (index...(index + sections.count))
        
        zip(sections, indexRange)
            .forEach { section, index in
                self.sections.insert(section, at: index)
        }

        register(sections: sections)
        let indexSet = IndexSet(integersIn: indexRange)
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(indexSet, with: animation)
        }
    }
    
    public func insert(section: OKTableViewSection, at index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        sections.insert(section, at: index)
        register(section: section)
        
        performTableViewUpdates(animated: animated) {
            tableView?.insertSections(IndexSet(integer: index), with: animation)
        }
    }
    
    public func emptySection(at index: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(index) else { return }
        
        let indexPaths = sections[index].rowIndexPaths(for: index)
        sections[index].removeAllRows()
        
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
    
    public func replaceSection(at index: Int, with section: OKTableViewSection, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {

        sections.remove(at: index)
        sections.insert(section, at: index)
        register(section: section)
        
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
    
    public func clearSections(replacedBy sections: [OKTableViewSection] = [],
                              animation: UITableViewRowAnimation = .automatic,
                              animated: Bool = true) {
        
        guard !self.sections.isEmpty else { return }
        
        let sectionsRange = 0...self.sections.lastIndex
        let indexSet = IndexSet(integersIn: sectionsRange)
        
        self.sections.removeAll()
        
        performTableViewUpdates(animated: animated) {
            tableView?.deleteSections(indexSet, with: animation)
        }
        
        append(sections: sections, animation: animation, animated: animated)
    }
    
    public func swapSection(at source: Int, with destination: Int, animation: UITableViewRowAnimation = .automatic, animated: Bool = true) {
        
        guard sections.indices.contains(source) && sections.indices.contains(destination) else { return }
        sections.swapAt(source, destination)
        
        performTableViewUpdates(animated: animated) {
            tableView?.moveSection(source, toSection: destination)
            tableView?.moveSection(destination, toSection: source)
        }
    }
}

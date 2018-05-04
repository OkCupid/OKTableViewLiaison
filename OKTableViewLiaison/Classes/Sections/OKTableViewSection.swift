//
//  OKTableViewSection.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/15/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

open class OKTableViewSection<Header: UITableViewHeaderFooterView, Footer: UITableViewHeaderFooterView, Model>: OKAnyTableViewSection {
    
    public let model: Model
    
    override weak var tableView: UITableView? {
        didSet {
            registerRowCells()
            registerHeaderFooterViews()
        }
    }
    
    private var headerCommands = [OKTableViewSectionCommand: (Header, Model, Int) -> Void]()
    private var footerCommands = [OKTableViewSectionCommand: (Footer, Model, Int) -> Void]()
    private let supplementaryViewDisplay: OKTableViewSectionSupplementaryViewDisplayOption
    private var heights = [OKTableViewSectionSupplementaryView: (Model) -> CGFloat]()
        
    public init(_ model: Model,
                rows: [OKAnyTableViewRow] = [],
                supplementaryViewDisplay: OKTableViewSectionSupplementaryViewDisplayOption = .none) {
        self.model = model
        self.supplementaryViewDisplay = supplementaryViewDisplay
        super.init(rows: rows)
        registerHeaderFooterViews()
    }
    
    // MARK: - Configuration
    public func setHeader(command: OKTableViewSectionCommand, with closure: @escaping ((Header, Model, _ section: Int) -> Void)) {
        headerCommands[command] = closure
    }
    
    public func removeHeader(command: OKTableViewSectionCommand) {
        headerCommands[command] = nil
    }
    
    public func setFooter(command: OKTableViewSectionCommand, with closure: @escaping ((Footer, Model, _ section: Int) -> Void)) {
        footerCommands[command] = closure
    }
    
    public func removeFooter(command: OKTableViewSectionCommand) {
        footerCommands[command] = nil
    }
    
    public func setHeight(for supplementaryView: OKTableViewSectionSupplementaryView, with closure: @escaping ((Model) -> CGFloat)) {
        heights[supplementaryView] = closure
    }
    
    public func setHeight(for supplementaryView: OKTableViewSectionSupplementaryView, value: CGFloat) {
        let closure: ((Model) -> CGFloat) = { _ -> CGFloat in return value }
        heights[supplementaryView] = closure
    }
    
    public func removeHeight(for supplementaryView: OKTableViewSectionSupplementaryView) {
        heights[supplementaryView] = nil
    }
    
    override public func calculateHeight(for supplementaryView: OKTableViewSectionSupplementaryView) -> CGFloat {
        
        switch (supplementaryViewDisplay, supplementaryView) {
        case (.both, _), (.header, .header), (.footer, .footer):
            return heights[supplementaryView]?(model) ?? UITableViewAutomaticDimension
        default:
            return 0
        }
    }

    // MARK: - Type Registration
    private func registerRowCells() {
        guard let tableView = tableView else {
            return
        }
        
        rows.forEach {
            $0.registerCellType(with: tableView)
        }
    }
    
    private func registerHeaderFooterViews() {
        
        if let header = supplementaryViewDisplay.headerRegistrationType {
            register(type: header, for: .header, with: Header.self)
        }
        
        if let footer = supplementaryViewDisplay.footerRegistrationType {
            register(type: footer, for: .footer, with: Footer.self)
        }
        
    }
    
    private func register(type: OKTableViewRegistrationType, for supplementaryView: OKTableViewSectionSupplementaryView, with view: UITableViewHeaderFooterView.Type) {
        switch type {
        case let .class(identifier):
            tableView?.register(view, forHeaderFooterViewReuseIdentifier: "\(supplementaryView.identifer)\(identifier)")
        case let .nib(nib, identifier):
            tableView?.register(nib, forHeaderFooterViewReuseIdentifier: "\(supplementaryView.identifer)\(identifier)")
        }
    }
    
    // MARK: - Supplementary Views
    override public func perform(command: OKTableViewSectionCommand, supplementaryView: OKTableViewSectionSupplementaryView, for view: UIView, in section: Int) {
        switch supplementaryView {
        case .header:
            if let header = view as? Header {
                headerCommands[command]?(header, model, section)
            }
            
        case .footer:
            if let footer = view as? Footer {
                footerCommands[command]?(footer, model, section)
            }
        }
    }
    
    override public func view(supplementaryView: OKTableViewSectionSupplementaryView, for tableView: UITableView, in section: Int) -> UIView? {
        switch supplementaryView {
        case .header:
            return header(for: tableView, in: section)
        case .footer:
            return footer(for: tableView, in: section)
        }
    }
    
    private func header(for tableView: UITableView, in section: Int) -> UIView? {
        
        guard let headerIdentifer = supplementaryViewDisplay.headerRegistrationType?.identifier else {
            return nil
        }
        
        let reuseIdentifier = "\(OKTableViewSectionSupplementaryView.header.identifer)\(headerIdentifer)"
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? Header else {
            return nil
        }
        
        headerCommands[.configuration]?(header, model, section)
        
        return header
    }
    
    private func footer(for tableView: UITableView, in section: Int) -> UIView? {
        
        guard let footerIdentifer = supplementaryViewDisplay.footerRegistrationType?.identifier else {
            return nil
        }
        
        let reuseIdentifier = "\(OKTableViewSectionSupplementaryView.footer.identifer)\(footerIdentifer)"
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? Footer else {
            return nil
        }
        
        footerCommands[.configuration]?(footer, model, section)
            
        return footer
    }
}

public extension OKTableViewSection where Model == Void {
    
    convenience public init(rows: [OKAnyTableViewRow] = [],
                            supplementaryViewDisplay: OKTableViewSectionSupplementaryViewDisplayOption = .none) {
        self.init((),
                  rows: rows,
                  supplementaryViewDisplay: supplementaryViewDisplay)
    }
}

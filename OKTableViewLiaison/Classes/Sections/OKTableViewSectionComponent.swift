//
//  OKTableViewSectionComponent.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import Foundation

open class OKTableViewSectionComponent<View: UITableViewHeaderFooterView, Model>: OKAnyTableViewSectionComponent {
    
    public let model: Model
    
    private let registrationType: OKTableViewRegistrationType<View>
    private var commands = [OKTableViewSectionComponentCommand: (View, Model, Int) -> Void]()
    private var heights = [OKTableViewHeightType: (Model) -> CGFloat]()
    
    public init(_ model: Model, registrationType: OKTableViewRegistrationType<View> = .defaultClassType) {
        self.model = model
        self.registrationType = registrationType
    }
    
    public func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
        let view = tableView.dequeue(View.self, with: reuseIdentifier)
        commands[.configuration]?(view, model, section)
        return view
    }
    
    public func register(with tableView: UITableView) {
        switch registrationType {
        case let .class(identifier):
            tableView.register(View.self, with: identifier)
        case let .nib(nib, identifier):
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    // MARK: - Commands
    public func perform(command: OKTableViewSectionComponentCommand, for view: UIView, in section: Int) {
        
        guard let view = view as? View else { return }
        
        commands[command]?(view, model, section)
    }
    
    public func set(command: OKTableViewSectionComponentCommand, with closure: @escaping (View, Model, Int) -> Void) {
        commands[command] = closure
    }
    
    public func remove(command: OKTableViewSectionComponentCommand) {
        commands[command] = nil
    }
    
    public func set(height: OKTableViewHeightType, _ closure: @escaping (Model) -> CGFloat) {
        heights[height] = closure
    }
    
    public func set(height: OKTableViewHeightType, _ value: CGFloat) {
        let closure: ((Model) -> CGFloat) = { _ -> CGFloat in return value }
        heights[height] = closure
    }
    
    public func remove(height: OKTableViewHeightType) {
        heights[height] = nil
    }
    
    // MARK: - Computed Properties
    public var height: CGFloat {
        return calculate(height: .height)
    }
    
    public var estimatedHeight: CGFloat {
        return calculate(height: .estimatedHeight)
    }
    
    public var reuseIdentifier: String {
        return registrationType.reuseIdentifier
    }
    
    // MARK: - Private
    private func calculate(height: OKTableViewHeightType) -> CGFloat {
        switch height {
        case .height:
            return heights[.height]?(model) ?? UITableViewAutomaticDimension
        case .estimatedHeight:
            return heights[.estimatedHeight]?(model) ?? heights[.height]?(model) ?? 0
        }
    }
}

public extension OKTableViewSectionComponent where Model == Void {
    
    public convenience init(registrationType: OKTableViewRegistrationType<View> = .defaultClassType) {
        self.init((),
                  registrationType: registrationType)
    }
}


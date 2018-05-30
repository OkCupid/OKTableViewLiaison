//
//  OKTableViewSectionSupplementaryView.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import Foundation

open class OKTableViewSectionComponent<View: UITableViewHeaderFooterView, Model>: OKAnyTableViewSectionComponent {
    
    public init(_ model: Model, registrationType: OKTableViewRegistrationType) {
        self.model = model
        self.registrationType = registrationType
    }
    
    private let model: Model
    public let registrationType: OKTableViewRegistrationType

    private var commands = [OKTableViewSectionComponentCommand: (View, Model, Int) -> Void]()
    private var heightClosure: ((Model) -> CGFloat)?
    
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
    
    public func setHeight(_ closure: @escaping (Model) -> CGFloat) {
        heightClosure = closure
    }
    
    public func setHeight(_ value: CGFloat) {
        let closure: ((Model) -> CGFloat) = { _ -> CGFloat in return value }
        heightClosure = closure
    }
    
    public func removeHeight() {
        heightClosure = nil
    }
    
    // MARK: - Computed Properties
    public var height: CGFloat {
        return heightClosure?(model) ?? UITableViewAutomaticDimension
    }
    
    public var reuseIdentifier: String {
        return registrationType.identifier
    }
    
    public func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
    
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? View else { return nil }
        
        commands[.configuration]?(view, model, section)
        
        return view
    }
    
    public func registerViewType(with tableView: UITableView) {
        switch registrationType {
        case let .class(identifier):
            tableView.register(View.self, forHeaderFooterViewReuseIdentifier: identifier)
        case let .nib(nib, identifier):
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
}

public extension OKTableViewSectionComponent where Model == Void {
    
    public convenience init(registrationType: OKTableViewRegistrationType = OKTableViewSectionComponent.defaultClassRegistrationType) {
        
        self.init((),
                  registrationType: registrationType)
    }
}

// MARK: - OKTableViewRegistrationType
public extension OKTableViewSectionComponent {
    
    public static var defaultClassRegistrationType: OKTableViewRegistrationType {
        return .defaultClassRegistration(for: View.self)
    }
    
    public static var defaultNibRegistrationType: OKTableViewRegistrationType {
        return .defaultNibRegistration(for: View.self)
    }
}

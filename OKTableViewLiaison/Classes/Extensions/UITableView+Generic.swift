//
//  UITableView+Generic.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 9/4/18.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ type: T.Type, with identifier: String) {
        register(T.self, forCellReuseIdentifier: identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ type: T.Type, with identifier: String) {
        register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type, with identifier: String) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue cell of type \(T.self).")
        }
        
        return cell
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type, with identifier: String) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Failed to dequeue view of type \(T.self).")
        }
        
        return view
    }
    
}

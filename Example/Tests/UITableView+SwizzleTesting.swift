//
//  UITableView+SwizzleTesting.swift
//  TableViewLiaisonTests
//
//  Created by Dylan Shine on 3/26/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

enum TableViewMethod {
    case reloadRows
    case cellForRow
    
    static var all: [TableViewMethod] {
        return [.reloadRows, .cellForRow]
    }
    
    var originalSelector: Selector {
        switch self {
        case .reloadRows:
            return #selector(UITableView.reloadRows(at:with:))
        case .cellForRow:
            return #selector(UITableView.cellForRow(at:))
        }
    }
    
    var swizzledSelector: Selector {
        switch self {
        case .reloadRows:
            return #selector(UITableView.incrementReloadRowsCount)
        case .cellForRow:
            return #selector(UITableView.stubCellForRow)
        }
    }
}

private var CallCountHandle: UInt8 = 0
private var StubCellHandle: UInt8 = 1
extension UITableView {
    
    var callCounts: [TableViewMethod: UInt] {
        get {
            return objc_getAssociatedObject(self, &CallCountHandle) as? [TableViewMethod: UInt] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &CallCountHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var stubCell: UITableViewCell? {
        get {
            return objc_getAssociatedObject(self, &StubCellHandle) as? UITableViewCell
        }
        set {
            objc_setAssociatedObject(self, &StubCellHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func performInSwizzledEnvironment(_ closure: () -> Void) {
        swizzle()
        closure()
        stubCell = nil
        swizzle()
    }
    
    private func swizzle() {
        
        guard let aClass = object_getClass(self) else {
            return
        }
        
        TableViewMethod.all.forEach{ method in
            let originalMethod = class_getInstanceMethod(aClass, method.originalSelector)
            let swizzledMethod = class_getInstanceMethod(aClass, method.swizzledSelector)
            
            if let original = originalMethod,
                let swizzled = swizzledMethod {
                method_exchangeImplementations(original, swizzled)
            }
        }
    }
    
    @objc fileprivate func incrementReloadRowsCount() {
        if let count = callCounts[.reloadRows] {
            callCounts[.reloadRows] = count + 1
        } else {
            callCounts[.reloadRows] = 1
        }
    }
    
    @objc fileprivate func stubCellForRow() -> UITableViewCell {
        guard let cell = stubCell else {
            fatalError("Must set a stub prior to invoking cellForRow")
        }
        
        return cell
    }
}

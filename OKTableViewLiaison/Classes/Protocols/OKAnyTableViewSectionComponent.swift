//
//  OKAnyTableViewSectionComponent.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import UIKit

public protocol OKAnyTableViewSectionComponent: AnyObject, OKTableViewRegistrable {
    var height: CGFloat { get }
    var estimatedHeight: CGFloat { get }
    var reuseIdentifier: String { get }
    func perform(command: OKTableViewSectionComponentCommand, for view: UIView, in section: Int)
    func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView?
}

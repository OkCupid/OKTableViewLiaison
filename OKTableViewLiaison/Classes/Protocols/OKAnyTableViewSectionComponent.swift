//
//  OKAnyTableViewSectionComponent.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import UIKit

public protocol OKAnyTableViewSectionComponent: OKTableViewContent {
    func perform(command: OKTableViewSectionComponentCommand, for view: UIView, in section: Int)
    func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView?
}

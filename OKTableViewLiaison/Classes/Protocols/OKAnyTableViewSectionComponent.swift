//
//  OKAnyTableViewSectionSupplementaryView.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 5/29/18.
//

import UIKit

public protocol OKAnyTableViewSectionComponent {
    func calculate(height: OKTableViewHeightType) -> CGFloat
    func registerViewType(with tableView: UITableView)
    func perform(command: OKTableViewSectionComponentCommand, for view: UIView, in section: Int)
    func view(for tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView?
}

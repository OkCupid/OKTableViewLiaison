//
//  OKPlainTableViewSection.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/30/18.
//

import UIKit

open class OKPlainTableViewSection: OKTableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, Void> {
    
    public init(rows: [OKAnyTableViewRow] = []) {
        super.init((), rows: rows, supplementaryViewDisplay: .none)
    }
    
}

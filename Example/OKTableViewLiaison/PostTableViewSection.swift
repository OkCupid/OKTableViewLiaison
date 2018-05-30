//
//  PostTableViewSection.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class PostTableViewSection: OKTableViewSection {
    
    init(user: User, rows: [OKAnyTableViewRow] = []) {
        super.init(rows: rows, componentDisplayOption: .header(component: PostTableViewSectionHeaderViewComponent(user: user)))
    }
    
}

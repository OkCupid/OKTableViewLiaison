//
//  TestTableViewSection.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/23/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit
@testable import OKTableViewLiaison

final class TestTableViewSection: OKTableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, Void> {
    
    static func create() -> TestTableViewSection {
        
        return TestTableViewSection((),
                                    supplementaryViewDisplay: .both(headerRegistrationType: TestTableViewSection.defaultHeaderClassRegistrationType,
                                                                    footerRegistrationType: TestTableViewSection.defaultFooterClassRegistrationType))
        
    }
    
}

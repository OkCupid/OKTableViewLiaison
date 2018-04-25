//
//  TestTableViewLiaisonPaginationDelegate.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/30/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import Foundation
@testable import OKTableViewLiaison

final class TestTableViewLiaisonPaginationDelegate: NSObject, OKTableViewLiaisonPaginationDelegate {
        
    @objc dynamic var isPaginationEnabledCallCount = 0
    func isPaginationEnabled() -> Bool {
        isPaginationEnabledCallCount += 1
        return true
    }
    
    @objc dynamic var paginationStartedCallCount = 0
    func paginationStarted(indexPath: IndexPath) {
        paginationStartedCallCount += 1
    }
    
    @objc dynamic var paginationEndedCallCount = 0
    func paginationEnded(indexPath: IndexPath) {
        paginationEndedCallCount += 1
    }
}

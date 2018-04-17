//
//  TestTableViewLiaisonPaginationDelegate.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/30/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import Foundation
@testable import OKTableViewLiaison

final class TestTableViewLiaisonPaginationDelegate: OKTableViewLiaisonPaginationDelegate {
    
    var isPaginationEnabledCallCount = 0
    func isPaginationEnabled() -> Bool {
        isPaginationEnabledCallCount += 1
        return true
    }
    
    var paginationStartedCallCount = 0
    func paginationStarted(indexPath: IndexPath) {
        paginationStartedCallCount += 1
    }
    
    var paginationEndedCallCount = 0
    func paginationEnded(indexPath: IndexPath) {
        paginationEndedCallCount += 1
    }
}

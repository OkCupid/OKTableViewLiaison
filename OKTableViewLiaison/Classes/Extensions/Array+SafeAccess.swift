//
//  Array+SafeAccess.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/20/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import Foundation

extension Array {
    
    func element(at index: Int) -> Element? {
        guard index < count else {
            return nil
        }
        
        return self[index]
    }
    
    var lastIndex: Index {
        guard !isEmpty else {
            return 0
        }
        
        return count - 1
    }

}

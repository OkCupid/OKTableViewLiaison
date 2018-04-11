//
//  Array+IndexPath.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 4/6/18.
//

import Foundation

extension Array where Element == IndexPath {
    
    func sortBySection() -> [Int: [IndexPath]] {
        var indexPathsBySection = [Int: [IndexPath]]()
        
        forEach { indexPath in
            if var indexPaths = indexPathsBySection[indexPath.section] {
                indexPaths.append(indexPath)
                indexPathsBySection[indexPath.section] = indexPaths.sorted(by: { (current, next) -> Bool in
                    current.item > next.item
                })
            } else {
                indexPathsBySection[indexPath.section] = [indexPath]
            }
        }
        
        return indexPathsBySection
    }
    
}

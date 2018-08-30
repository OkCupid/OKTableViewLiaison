//
//  OKPaginationTableViewRow.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/30/18.
//

import UIKit

final class OKPaginationTableViewRow: OKTableViewRow<OKPaginationTableViewCell, Void> {
    
    public init() {
        super.init(())
        
        set(command: .configuration) { cell, _, _ in
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
        }
        
        set(command: .willDisplay) { cell, _, _ in
            cell.spinner.startAnimating()
        }
        
    }
    
}

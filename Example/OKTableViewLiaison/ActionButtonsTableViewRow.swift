//
//  ActionButtonsTableViewRow.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import OKTableViewLiaison

final class ActionButtonsTableViewRow: OKTableViewRow<ActionButtonsTableViewCell, Void> {
    
    init() {
        super.init((), registrationType: ActionButtonsTableViewRow.defaultNibRegistrationType)
        
        set(height: .height, value: 30)
        set(command: .configuration) { cell, _, _ in
            cell.likeButton.setTitle("❤️", for: .normal)
            cell.commentButton.setTitle("💬", for: .normal)
            cell.messageButton.setTitle("📮", for: .normal)
            cell.bookmarkButton.setTitle("📚", for: .normal)
            cell.selectionStyle = .none
        }
    }
  
}

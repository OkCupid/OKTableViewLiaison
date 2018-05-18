//
//  PostTextTableViewRow.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class TextTableViewRow: OKTableViewRow<TextTableViewCell, String> {
    
    init(text: String) {
        super.init(text,
                   registrationType: TextTableViewRow.defaultNibRegistrationType)
    }
    
    static func likesRow(numberOfLikes: UInt) -> TextTableViewRow {

        let row = TextTableViewRow(text: "\(numberOfLikes) likes")
        
        row.set(command: .configuration) { cell, string, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.contentTextLabel.text = string
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func captionRow(user: String, caption: String) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: caption)
        
        row.set(command: .configuration) { cell, caption, _ in
            
            cell.contentTextLabel.numberOfLines = 0
            cell.selectionStyle = .none

            let mediumAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: UIColor.black
            ]
            
            let regularAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black
            ]
            
            let attributedString = NSMutableAttributedString(string: user, attributes: mediumAttributes)
            
            attributedString.append(NSMutableAttributedString(string: " \(caption)", attributes: regularAttributes))
            
            cell.contentTextLabel.attributedText = attributedString
        }
        
        return row
    }
    
    static func commentRow(commentCount: UInt) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: "View all \(commentCount) comments")
        
        row.set(command: .configuration) { cell, string, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 13)
            cell.contentTextLabel.text = string
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: TimeInterval) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: numberOfSeconds.timeText)

        row.set(command: .configuration) { cell, string, _ in
            cell.contentTextLabel.font = .systemFont(ofSize: 10)
            cell.contentTextLabel.text = string
            cell.contentTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
}

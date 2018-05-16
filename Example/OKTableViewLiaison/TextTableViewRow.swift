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
    
    static func likesRow(numberOfLikes: Int) -> TextTableViewRow {

        let row = TextTableViewRow(text: "\(numberOfLikes) likes")
        
        row.set(height: .height, value: 20)
        row.set(command: .configuration) { cell, string, _ in
            cell.postTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.postTextLabel.text = string
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func captionRow(user: String, caption: String) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: caption)
        
        row.set(command: .configuration) { cell, caption, _ in
            
            cell.postTextLabel.numberOfLines = 0
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
            
            cell.postTextLabel.attributedText = attributedString
        }
        
        return row
    }
    
    static func commentRow(commentCount: Int) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: "View all \(commentCount) comments")
        
        row.set(height: .height, value: 20)
        row.set(command: .configuration) { cell, string, _ in
            cell.postTextLabel.font = .systemFont(ofSize: 13)
            cell.postTextLabel.text = string
            cell.postTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: TimeInterval) -> TextTableViewRow {
        
        let row = TextTableViewRow(text: numberOfSeconds.timeText)

        row.set(height: .height, value: 15)
        row.set(command: .configuration) { cell, string, _ in
            cell.postTextLabel.font = .systemFont(ofSize: 10)
            cell.postTextLabel.text = string
            cell.postTextLabel.textColor = .gray
            cell.selectionStyle = .none
        }
        
        return row
    }
    
}

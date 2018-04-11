//
//  PostTextTableViewRow.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class PostTextTableViewRow: OKTableViewRow<PostTextTableViewCell, String> {
    
    init(text: String) {
        super.init(text,
                   registrationType: .defaultNibRegistration(for: PostTextTableViewCell.self))
    }
    
    static func likesRow(numberOfLikes: Int) -> PostTextTableViewRow {
        let text =  "\(numberOfLikes) likes"
        let row = PostTextTableViewRow(text: text)
        
        row.set(height: .height, value: 25)
        row.set(command: .configuration) { (cell, string, _) in
            cell.postTextLabel.font = .systemFont(ofSize: 13, weight: .medium)
            cell.postTextLabel.text = string
        }
        
        return row
    }
    
    static func captionRow(user: String, caption: String) -> PostTextTableViewRow {
        
        let row = PostTextTableViewRow(text: "")
        
        row.set(command: .configuration) { (cell, _, _) in
            
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
    
    static func commentRow(commentCount: Int) -> PostTextTableViewRow {
        
        let text = "View all \(commentCount) comments"
        
        let row = PostTextTableViewRow(text: text)
        
        row.set(height: .height, value: 25)
        row.set(command: .configuration) { (cell, string, _) in
            cell.postTextLabel.font = .systemFont(ofSize: 13)
            cell.postTextLabel.text = string
            cell.postTextLabel.textColor = .gray
        }
        
        return row
    }
    
    static func timeRow(numberOfSeconds: Int) -> PostTextTableViewRow {
        
        let row = PostTextTableViewRow(text: numberOfSeconds.timeText)

        row.set(height: .height, value: 20)
        row.set(command: .configuration) { (cell, string, _) in
            cell.postTextLabel.font = .systemFont(ofSize: 10)
            cell.postTextLabel.text = string
            cell.postTextLabel.textColor = .gray
        }
        
        return row
    }
    
}

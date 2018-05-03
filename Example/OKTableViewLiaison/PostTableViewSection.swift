//
//  PostTableViewSection.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class PostTableViewSection: OKTableViewSection<PostTableViewSectionHeaderView, UITableViewHeaderFooterView, Post> {
    
    private let width: CGFloat
    
    init(post: Post, width: CGFloat) {
        let registration = OKTableViewRegistrationType.defaultNibRegistration(for: PostTableViewSectionHeaderView.self)
        self.width = width
        
        super.init(post, rows: PostTableViewSection.rows(for: post, width: width), supplementaryViewDisplay: .header(registrationType: registration))
        
        setHeight(for: .header, value: 70)
        
        setHeader(command: .configuration) { (header, post, section) in
            
            header.backgroundView = UIView(frame: header.bounds)
            header.backgroundView?.backgroundColor = .white
            
            header.imageView.layer.masksToBounds = true
            header.imageView.layer.cornerRadius = 19
            header.imageView.layer.borderColor = UIColor.gray.cgColor
            header.imageView.layer.borderWidth = 1
            header.imageView.contentMode = .scaleAspectFit
            header.imageView.image = post.user.avatar
            
            header.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            header.titleLabel.textColor = .black
            header.titleLabel.text = post.user.username
        }
        
    }
    
    private static func rows(for post: Post, width: CGFloat) -> [OKAnyTableViewRow] {
        return [PostTableViewSection.contentRow(with: post.content, width: width),
                PostTableViewSection.actionsRow,
                PostTextTableViewRow.likesRow(numberOfLikes: post.numberOfLikes),
                PostTextTableViewRow.captionRow(user: post.user.username, caption: post.caption),
                PostTextTableViewRow.commentRow(commentCount: post.numberOfComments),
                PostTextTableViewRow.timeRow(numberOfSeconds: post.timePosted)]
    }
    
    private static func contentRow(with image: UIImage, width: CGFloat) -> OKAnyTableViewRow {
        let row = OKTableViewRow<PostImageContentTableViewCell, UIImage>(image,
                                                                       registrationType: .defaultNibRegistration(for: PostImageContentTableViewCell.self))
        
        row.set(height: .height) { (image) -> CGFloat in
            
            let ratio = image.size.width / image.size.height
            
            return width / ratio
        }
        
        row.set(command: .configuration) { (cell, image, _) in
            cell.contentImageView.image = image
            cell.contentImageView.contentMode = .scaleAspectFill
        }
        
        return row
    }
    
    private static var actionsRow: OKAnyTableViewRow {
        
        let row = OKTableViewRow<PostActionsTableViewCell, Void>(registrationType: .defaultNibRegistration(for: PostActionsTableViewCell.self))
        
        row.set(height: .height, value: 40)
        row.set(command: .configuration) { (cell, _, _) in
            cell.likeButton.setTitle("❤️", for: .normal)
            cell.commentButton.setTitle("💬", for: .normal)
            cell.messageButton.setTitle("📮", for: .normal)
            cell.bookmarkButton.setTitle("📚", for: .normal)
            cell.selectionStyle = .none
        }

        return row
    }
}

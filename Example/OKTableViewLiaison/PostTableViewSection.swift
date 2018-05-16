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
    
    init(post: Post, width: CGFloat) {
        let registration = OKTableViewRegistrationType.defaultNibRegistration(for: PostTableViewSectionHeaderView.self)
        
        super.init(post, rows: PostTableViewSection.rows(for: post, width: width), supplementaryViewDisplay: .header(registrationType: registration))
        
        setHeight(for: .header, value: 70)
        
        setHeader(command: .configuration) { header, post, section in
            
            header.backgroundView = UIView(frame: header.bounds)
            header.backgroundView?.backgroundColor = .white
            
            header.imageView.layer.masksToBounds = true
            header.imageView.layer.cornerRadius = 19
            header.imageView.layer.borderColor = UIColor.gray.cgColor
            header.imageView.layer.borderWidth = 1
            header.imageView.contentMode = .scaleAspectFit
            header.imageView.image = post.user.avatar
            
            header.titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
            header.titleLabel.textColor = .black
            header.titleLabel.text = post.user.username
        }
        
    }
    
    private static func rows(for post: Post, width: CGFloat) -> [OKAnyTableViewRow] {
        return [ImageContentTableViewRow(image: post.content, width: width),
                ActionButtonsTableViewRow(),
                TextTableViewRow.likesRow(numberOfLikes: post.numberOfLikes),
                TextTableViewRow.captionRow(user: post.user.username, caption: post.caption),
                TextTableViewRow.commentRow(commentCount: post.numberOfComments),
                TextTableViewRow.timeRow(numberOfSeconds: post.timePosted)]
    }
    
}

//
//  PostTableViewSectionFactory.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/18/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import OKTableViewLiaison

enum PostTableViewSectionFactory {
    
    static func section(for post: Post) -> PostTableViewSection {
        let rows: [OKAnyTableViewRow] = [
            ImageTableViewRow(image: post.content),
            ActionButtonsTableViewRow(),
            TextTableViewRowFactory.likesRow(numberOfLikes: post.numberOfLikes),
            TextTableViewRowFactory.captionRow(user: post.user.username, caption: post.caption),
            TextTableViewRowFactory.commentRow(commentCount: post.numberOfComments),
            TextTableViewRowFactory.timeRow(numberOfSeconds: post.timePosted)
        ]
        
        return PostTableViewSection(user: post.user, rows: rows)
    }
    
}

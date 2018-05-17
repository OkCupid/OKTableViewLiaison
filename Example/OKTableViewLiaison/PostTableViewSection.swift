//
//  PostTableViewSection.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class PostTableViewSection: OKTableViewSection<PostTableViewSectionHeaderView, UITableViewHeaderFooterView, User> {
    
    init(user: User, rows: [OKAnyTableViewRow] = []) {
        let registrationType = PostTableViewSection.defaultHeaderNibRegistrationType
        
        super.init(user, rows: rows, supplementaryViewDisplay: .header(registrationType: registrationType))
        
        setHeight(for: .header, value: 70)
        
        setHeader(command: .configuration) { header, user, section in
            header.backgroundView?.backgroundColor = .white
            
            header.imageView.image = user.avatar
            header.imageView.layer.borderColor = UIColor.gray.cgColor
            header.imageView.layer.borderWidth = 1
            
            header.titleLabel.text = user.username
            header.titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
            header.titleLabel.textColor = .black
        }
    }
    
}

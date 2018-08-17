//
//  PostTableViewSectionHeaderViewComponent.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class PostTableViewSectionHeaderViewComponent: OKTableViewSectionComponent<PostTableViewSectionHeaderView, User> {
    
    public init(user: User) {
        
        super.init(user, registrationType: .defaultNibType)
        
        set(height: .height, 70)
    
        set(command: .configuration) { view, user, section in
            view.imageView.image = user.avatar
            view.imageView.layer.borderColor = UIColor.gray.cgColor
            view.imageView.layer.borderWidth = 1
            
            view.titleLabel.text = user.username
            view.titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
            view.titleLabel.textColor = .black
        }
    }
}

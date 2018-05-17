//
//  PostTableViewSectionHeaderView.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit

final class PostTableViewSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // There is a UIKit bug where outlets for the view will be nil on first layout pass.
        guard imageView != nil else { return }
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
}

//
//  TextTableViewCell.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/29/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTextLabel.text = nil
        postTextLabel.textColor = .black
        postTextLabel.attributedText = nil
    }
    
}

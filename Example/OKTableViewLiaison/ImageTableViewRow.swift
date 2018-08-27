//
//  ImageTableViewRow.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import OKTableViewLiaison

final class ImageTableViewRow: OKTableViewRow<ImageTableViewCell, UIImage> {
    
    init(image: UIImage, tableView: UITableView) {
        
        super.init(image, registrationType: .defaultNibType)
        
        set(height: .height) { [weak tableView] image -> CGFloat in
            
            guard let tableView = tableView else {
                return 0
            }
            
            let ratio = image.size.width / image.size.height

            return tableView.frame.width / ratio
        }
        
        set(command: .configuration) { cell, image, indexPath in
            cell.contentImageView.image = image
            cell.contentImageView.contentMode = .scaleAspectFill
        }
    }
}


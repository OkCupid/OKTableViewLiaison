//
//  ImageTableViewRow.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import OKTableViewLiaison

final class ImageContentTableViewRow: OKTableViewRow<ContentImageTableViewCell, UIImage> {
    
    init(image: UIImage, width: CGFloat) {
        
        super.init(image, registrationType: .defaultNibRegistration(for: ContentImageTableViewCell.self))
        
        set(height: .height) { image -> CGFloat in
            let ratio = image.size.width / image.size.height
            return width / ratio
        }
        
        set(command: .configuration) { cell, image, _ in
            cell.contentImageView.image = image
            cell.contentImageView.contentMode = .scaleAspectFill
        }
    }
    
}


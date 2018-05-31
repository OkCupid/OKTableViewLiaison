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
    
    init(image: UIImage) {
        
        super.init(image, registrationType: ImageTableViewRow.defaultNibRegistrationType)
        
        set(height: .height) { image -> CGFloat in
            let ratio = image.size.width / image.size.height
            return UIScreen.main.bounds.width / ratio
        }
        
        set(command: .configuration) { cell, image, indexPath in
            cell.contentImageView.image = image
            cell.contentImageView.contentMode = .scaleAspectFill
        }
    }
    
}


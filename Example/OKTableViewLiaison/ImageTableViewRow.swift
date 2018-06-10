//
//  ImageTableViewRow.swift
//  OKTableViewLiaison_Example
//
//  Created by Dylan Shine on 5/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import OKTableViewLiaison

final class ImageTableViewRow: OKTableViewRow<ImageTableViewCell, (UIImage, CGFloat)> {
    
    init(image: UIImage, width: CGFloat) {
        
        super.init((image, width), registrationType: ImageTableViewRow.defaultNibRegistrationType)
        
        set(height: .height) { model -> CGFloat in
            let (image, width) = model
            let ratio = image.size.width / image.size.height
            return width / ratio
        }
        
        set(command: .configuration) { cell, model, indexPath in
            cell.contentImageView.image = model.0
            cell.contentImageView.contentMode = .scaleAspectFill
        }
    }
    
}


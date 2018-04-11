//
//  UIView+Nib.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/20/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: .main)
    }
    
}

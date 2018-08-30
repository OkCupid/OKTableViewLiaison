//
//  OKPaginationTableViewCell.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 3/30/18.
//

import UIKit

final class OKPaginationTableViewCell: UITableViewCell {
    
    private let verticalSpacingConstant: CGFloat = 5
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalSpacingConstant).isActive = true
        spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalSpacingConstant).isActive = true
    }
}

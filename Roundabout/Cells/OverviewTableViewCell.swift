//
//  OverviewTableViewCell.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/27/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class OverviewTableViewCell: UITableViewCell {
    
    var placeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        l.textColor = UIColor.darkGray
        return l
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont(name: "HelveticaNeue", size: 16.0)
        l.textColor = UIColor.gray
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        selectionStyle = .none
        
        contentView.addSubview(placeLabel)
        contentView.addSubview(nameLabel)
        
        placeLabel.leadingAnchor == contentView.leadingAnchor + 20
        placeLabel.centerYAnchor == contentView.centerYAnchor
        
        nameLabel.leadingAnchor == placeLabel.trailingAnchor + 10
        nameLabel.centerYAnchor == contentView.centerYAnchor
    }
}

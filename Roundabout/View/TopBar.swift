//
//  TopBar.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class TopBar: UIView {

    var distanceLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        l.textColor = UIColor.init(named: "textColor")
        return l
    }()
    
    var instructionLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.init(named: "textColor")
        l.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
        return l
    }()
    
    var didSetConstraints = false
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.init(named: "bg")
        
        addSubview(distanceLabel)
        addSubview(instructionLabel)
    }
    
    override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        guard !didSetConstraints else {
            return
        }
        didSetConstraints = true
        
        distanceLabel.topAnchor == safeAreaLayoutGuide.topAnchor + 6
        distanceLabel.leadingAnchor == leadingAnchor + 70
        
        instructionLabel.topAnchor == distanceLabel.bottomAnchor + 1
        instructionLabel.leadingAnchor == distanceLabel.leadingAnchor
        instructionLabel.bottomAnchor == bottomAnchor - 15
    }
}

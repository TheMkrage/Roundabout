//
//  BottomBar.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

protocol BottomBarDelegate: class {
    func close()
}

class BottomBar: UIView {
    
    var destinationLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        l.textColor = UIColor.init(named: "textColor")
        return l
    }()
    
    var timeLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.init(named: "textColor")
        l.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        return l
    }()
    
    let closeButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        b.setTitle("X", for: .normal)
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        return b
    }()
    
    weak var delegate: BottomBarDelegate?
    
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
        backgroundColor = UIColor.init(named: "bg")?.withAlphaComponent(0.65)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        addSubview(destinationLabel)
        addSubview(timeLabel)
        addSubview(closeButton)
    }
    
    override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        guard !didSetConstraints else {
            return
        }
        didSetConstraints = true
        
        destinationLabel.topAnchor == topAnchor + 8
        destinationLabel.leadingAnchor == leadingAnchor + 40
        
        closeButton.centerYAnchor == destinationLabel.centerYAnchor
        closeButton.leadingAnchor == leadingAnchor + 6
        
        timeLabel.topAnchor == destinationLabel.bottomAnchor + 2
        timeLabel.leadingAnchor == destinationLabel.leadingAnchor
        timeLabel.bottomAnchor == safeAreaLayoutGuide.bottomAnchor - 5
    }
    
    @objc func close() {
        delegate?.close()
    }
}

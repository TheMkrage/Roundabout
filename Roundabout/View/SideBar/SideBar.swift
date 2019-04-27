//
//  SideBar.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit

class SideBar: UIView {
    
    var percent: CGFloat = 0.20
    //var points = [Waypoint]()

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
        clipsToBounds = true
        
        backgroundColor = UIColor.init(named: "bg")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(frame.width/2.0)
        layer.cornerRadius = frame.width / 2.0
    }
    
    override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        guard !didSetConstraints else {
            return
        }
        didSetConstraints = true
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //UIBezierPath()
        
        // draw filled portion
        let percentHeight = rect.height * percent
        let path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: rect.height - percentHeight, width: rect.width, height: percentHeight), cornerRadius: layer.cornerRadius)
        UIColor.init(named: "health")?.setFill()
        path.fill()
    }
 

}

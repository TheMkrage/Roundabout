//
//  SideBar.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class SideBar: UIView {
    
    var percent: CGFloat = 0.02
    //var points = [Waypoint]()

    lazy var bitmoji: UIImageView = {
        let u = UIImageView()
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
        
        let variables = ["page": "bitmoji"]
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
            
            let displayName = me["displayName"] as? String
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = (bitmoji["avatar"] as! String)
                
                let url = URL(string: bitmojiAvatarUrl!)
                u.sd_setImage(with: url, completed: nil)
            }
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
        return u
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
        
        backgroundColor = .clear
        addSubview(bitmoji)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2.0
        setNeedsDisplay()
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
        super.draw(rect)
        let percentHeight = rect.height * percent
        let yCord = rect.height - percentHeight
        let bitmojiWidth: CGFloat = 50.0
        let bitmojiX: CGFloat = rect.midX - CGFloat(bitmojiWidth/2.0)
        bitmoji.frame = CGRect(x: bitmojiX, y: yCord - CGFloat(bitmojiWidth/2.0), width: bitmojiWidth, height: bitmojiWidth)
        
        // draw filled portion
        let bgPath = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
        UIColor.init(named: "bg")?.setFill()
        bgPath.fill()
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: yCord, width: rect.width, height: percentHeight), cornerRadius: layer.cornerRadius)
        UIColor.init(named: "health")?.setFill()
        path.fill()
    }
 

}

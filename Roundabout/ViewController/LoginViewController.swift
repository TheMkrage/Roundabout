//
//  LoginViewController.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/27/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Anchorage

class LoginViewController: UIViewController {

    lazy var loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
        DispatchQueue.main.async {
            let vc = DesignViewController()
            self.show(vc, sender: self)
        }
    }
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Raleway-Regular", size: 36.0)
        l.textColor = .lightGray
        l.addCharactersSpacing(spacing: 4.0, text: "ROUNDABOUT")
        return l
    }()
    
    var icon: UIImageView = {
        let u = UIImageView(image: UIImage.init(named: "heart"))
        u.contentMode = .scaleToFill
        return u
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(named: "bg")

        view.addSubview(loginButton!)
        view.addSubview(titleLabel)
        view.addSubview(icon)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titleLabel.centerXAnchor == view.centerXAnchor
        titleLabel.centerYAnchor == view.centerYAnchor - 50
        
        icon.widthAnchor == 100
        icon.heightAnchor == 100
        icon.centerXAnchor == view.centerXAnchor
        icon.bottomAnchor == titleLabel.topAnchor - 35
        
        loginButton!.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 35
        loginButton!.leadingAnchor == view.leadingAnchor + 30
        loginButton!.trailingAnchor == view.trailingAnchor - 30
        loginButton!.heightAnchor == 50
    }
}

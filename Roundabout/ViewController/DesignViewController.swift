//
//  DesignViewController.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/27/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Tags
import Anchorage

class DesignViewController: UIViewController {

    lazy var topBar: UIView = {
        let t = UIView()
        t.backgroundColor = UIColor.init(named: "bg")
        
        let label = UILabel()
        label.text = "Design your Jog"
        label.textColor = UIColor.init(named: "textColor")
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        t.addSubview(label)
        label.centerXAnchor == t.centerXAnchor
        label.bottomAnchor == t.bottomAnchor - 15
        
        return t
    }()
    
    var interestLabel: UILabel = {
        let x = UILabel()
        x.textColor = UIColor.gray
        x.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        x.text = "What would you like to see?"
        return x
    }()
    
    var tags = ["Coffee", "Books", "Church", "Nature", "Statues", "Food", "Music", "Amusement Parks"]
    var selectedTags = [String]()
    
    lazy var tagsView: TagsView = {
        let t = TagsView()
        t.paddingVertical = 5.0
        t.paddingHorizontal = 10.0
        t.tagLayerColor = TagButton.unselectedOptions.layerColor
        t.tagLayerRadius = TagButton.unselectedOptions.layerRadius
        t.tagLayerWidth = TagButton.unselectedOptions.layerWidth
        t.tagTitleColor = TagButton.unselectedOptions.tagTitleColor
        t.tagFont = TagButton.unselectedOptions.tagFont
        t.tagBackgroundColor = TagButton.unselectedOptions.tagBackgroundColor
        t.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        let last = TagButton()
        last.setTitle("+", for: .normal)
        last.setSelected()
        t.lastTagButton(last)
        
        t.append(contentsOf: tags)
        t.delegate = self
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(interestLabel)
        view.addSubview(tagsView)
        view.addSubview(topBar)
        setupConstraints()
    }
    
    private func setupConstraints() {
        topBar.topAnchor == view.topAnchor
        topBar.bottomAnchor == view.safeAreaLayoutGuide.topAnchor + 50
        topBar.horizontalAnchors == view.horizontalAnchors
        
        interestLabel.topAnchor == topBar.bottomAnchor + 20
        interestLabel.leadingAnchor == view.leadingAnchor + 20
        
        tagsView.topAnchor == interestLabel.bottomAnchor + 7
        tagsView.leadingAnchor == view.leadingAnchor + 15
        tagsView.trailingAnchor == view.trailingAnchor - 20
    }
}

extension DesignViewController: TagsDelegate{
    
    // Tag Touch Action
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        if selectedTags.contains(tagButton.currentTitle!) {
            selectedTags.removeAll { (s) -> Bool in
                return s == tagButton.currentTitle!
            }
            tagButton.setUnselected()
            tagButton.setUnselected()
        } else {
            selectedTags.append(tagButton.currentTitle!)
            tagButton.setSelected()
            tagButton.setSelected()
        }
        tagsView.layoutSubviews()
    }
    
    // Last Tag Touch Action
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
        let alert = UIAlertController(title: "What are you interested in?", message: "We will factor this into creating your jog!", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Coffee, Reading, etc"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            self.tags.append(text)
            self.selectedTags.append(text)
            
            let button = TagButton()
            button.setSelected()
            button.setTitle(text, for: .normal)
            self.tagsView.append(button)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // TagsView Change Height
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
        
    }
}

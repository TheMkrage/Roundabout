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

extension TagButton {
    func setSelected() {
        var options = ButtonOptions(
            layerColor: UIColor.init(named: "health")!, // layer Color
            layerRadius: 12.0, // layer Radius
            layerWidth: 1.0, // layer Width
            tagTitleColor: UIColor.white, // title Color
            tagFont: UIFont(name: "HelveticaNeue-Light", size: 16.0)!, // Font
            tagBackgroundColor: UIColor.init(named: "health")!, // Background Color
            lineBreakMode: NSLineBreakMode.byTruncatingMiddle //break Mode
        )
        options.paddingHorizontal = 12.0
        options.paddingVertical = 7.0

        setEntity(options)
    }
    
    static var unselectedOptions = ButtonOptions(
        layerColor: UIColor.init(named: "tag")!, // layer Color
        layerRadius: 12.0, // layer Radius
        layerWidth: 1.0, // layer Width
        tagTitleColor: UIColor.white,
        tagFont: UIFont(name: "HelveticaNeue-Light", size: 16.0)!,
        tagBackgroundColor: UIColor.init(named: "tag")!, // Background Color
        lineBreakMode: NSLineBreakMode.byCharWrapping //break Mode,
    )
    
    func setUnselected() {
        TagButton.unselectedOptions.paddingHorizontal = 12.0
        TagButton.unselectedOptions.paddingVertical = 7.0
        setEntity(TagButton.unselectedOptions)
    }
}

class DesignViewController: UIViewController {

    lazy var topBar: UIView = {
        let t = UIView()
        return t
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
        
        view.addSubview(tagsView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tagsView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        tagsView.leadingAnchor == view.leadingAnchor + 20
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

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
import SCSDKLoginKit
import SDWebImage
import CoreLocation

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
    
    var tags = ["Library", "Church", "Park", "Cafe", "Campground", "Aquarium", "Museum", "Store" ,"Bakery"]
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
    
    var distance: Double = 4.5 {
        didSet {
            distanceLabel.text = "\(distance.rounded(toPlaces: 2)) mi"
        }
    }
    var distanceLabel: UILabel = {
        let x = UILabel()
        x.textColor = UIColor.init(named: "textColor")
        x.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        x.text = "4.50 mi"
        return x
    }()
    
    lazy var slider: UISlider = {
        let s = UISlider()
        s.setValue(0.5, animated: false)
        s.tintColor = UIColor(named: "health")
        s.addTarget(self, action: #selector(sliderUpdated(_:)), for: .valueChanged)
        return s
    }()
    
    lazy var goButton: UIButton = {
        let x = UIButton()
        x.layer.borderColor = UIColor(named: "health")?.cgColor
        x.layer.borderWidth = 2.0
        x.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        x.setTitle("GO", for: .normal)
        x.setTitleColor(UIColor(named: "health"), for: .normal)
        x.layer.cornerRadius = 10.0
        x.isUserInteractionEnabled = true
        x.addTarget(self, action: #selector(generate(_:)), for: .touchUpInside)
        return x
    }()
    
    var waypoints = [Waypoint]()
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 40.0, right: 0.0)
        return t
    }()
    
    lazy var submitButton: UIButton = {
        let x = UIButton()
        x.backgroundColor = UIColor(named: "health")
        x.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)

        let attributedTitle = NSAttributedString(string: "START", attributes: [NSAttributedString.Key.kern: 2.5, NSAttributedString.Key.foregroundColor: UIColor.white])
        x.setAttributedTitle(attributedTitle, for: .normal)
        x.layer.cornerRadius = 20.0
        x.addTarget(self, action: #selector(start(_:)), for: .touchUpInside)
        x.isHidden = true
        return x
    }()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        view.addSubview(interestLabel)
        view.addSubview(tagsView)
        view.addSubview(topBar)
        view.addSubview(distanceLabel)
        view.addSubview(slider)
        view.addSubview(goButton)
        view.addSubview(tableView)
        view.addSubview(submitButton)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waypoints = []
        tableView.reloadData()
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
        
        distanceLabel.centerXAnchor == view.centerXAnchor
        distanceLabel.topAnchor == tagsView.bottomAnchor + 30
        
        slider.leadingAnchor == view.leadingAnchor + 20
        slider.topAnchor == distanceLabel.bottomAnchor + 10
        slider.trailingAnchor == view.trailingAnchor - 20
        
        goButton.widthAnchor == 60
        goButton.heightAnchor == 25
        goButton.centerXAnchor == view.centerXAnchor
        goButton.topAnchor == slider.bottomAnchor + 10
        
        tableView.topAnchor == goButton.bottomAnchor + 20
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == submitButton.topAnchor - 20
        
        submitButton.leadingAnchor == view.leadingAnchor + 60
        submitButton.trailingAnchor == view.trailingAnchor - 60
        submitButton.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 20
        submitButton.heightAnchor == 40.0
    }
    
    @objc func sliderUpdated(_ sender: UISlider) {
        distance = 2.0 + (Double(sender.value) * 5.0)
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    @objc func generate(_ sender: UIButton) {
        waypoints = []
        WaypointStore.shared.get(categories: selectedTags, startingPoint: lastLocation.coordinate, distance: distance) { (waypoints) in
            self.waypoints = waypoints
            self.tableView.reloadData()
        }
        
        submitButton.animateFromBottom(superView: self.view)
    }
    
    @objc func start(_ sender: UIButton) {
        let vc = MapViewController()
        vc.waypoints = waypoints
        show(vc, sender: self)
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

extension DesignViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let waypoint = waypoints[indexPath.row]
        
        let cell = OverviewTableViewCell(style: .default, reuseIdentifier: "overview")
        cell.placeLabel.text = "\(indexPath.row)"
        cell.nameLabel.text = waypoint.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension DesignViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
    }
}

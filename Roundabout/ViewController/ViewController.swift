//
//  ViewController.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import ARCL
import CoreLocation
import ARKit
import Anchorage

class ViewController: UIViewController {
    
    // Views
    let topBar = TopBar()
    let bottomBar = BottomBar()
    let sideBar = SideBar()
    var map: CompanionMapView!
    
    var timer: Timer!
    
    let pyramidGeometry = SCNPyramid(width: 0.01, height: 0.02, length: 0.0108)
    lazy var pyramidNode = SCNNode(geometry: pyramidGeometry)
    
    var marked = CLLocation(latitude: 32.8855781716564785, longitude: -117.23935240809809)
    var lastLocation = CLLocation(latitude: 32.8855781716564785, longitude: -117.23935240809809)
    var lastX = 0.0
    
    var waypoints = [Waypoint]()
    
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = CompanionMapView()
        
        // Table Codes
        let exit = getBigBox(image: UIImage.init(named: "Tile")!)
        exit.position = SCNVector3(-32, 1, -45)
        sceneLocationView.scene.rootNode.addChildNode(exit)
        let exitWaypoint = Waypoint(name: "Exit", latitude: 32.88580559622921, longitude: -117.2395439592874, altitude: 123.15, percent: 0.10)
        waypoints.append(exitWaypoint)
        
        let elevator = getBigBox(image: UIImage.init(named: "Tile")!)
        elevator.position = SCNVector3(-20, 1, -30)
        sceneLocationView.scene.rootNode.addChildNode(elevator)
        let elevatorWaypoint = Waypoint(name: "Elevator", latitude: 32.88605641907343, longitude: -117.23952412679434, altitude: 123.15, percent: 0.10)
        waypoints.append(elevatorWaypoint)
        
        let bathroom = getBigBox(image: UIImage.init(named: "Tile")!)
        bathroom.position = SCNVector3(-15, 1, -40)
        sceneLocationView.scene.rootNode.addChildNode(bathroom)
        let bathroomWaypoint = Waypoint(name: "Bathroom", latitude: 32.88632847330899, longitude: -117.23952955036582, altitude: 123.15, percent: 0.10)
        waypoints.append(bathroomWaypoint)
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        sceneLocationView.run()
        
        topBar.instructionLabel.text = "Turn right on Broadway Ave"
        topBar.distanceLabel.text = "69 Feet"
        
        bottomBar.destinationLabel.text = "Joe's Magic Coffee"
        bottomBar.timeLabel.text = "About 10 min away"
        
        view.addSubview(sceneLocationView)
        view.addSubview(topBar)
        view.addSubview(bottomBar)
        view.addSubview(sideBar)
        view.addSubview(map)
        
        // Make Pyramid
        let materialPyr = SCNMaterial()
        materialPyr.diffuse.contents = UIImage.init(named: "gradient")
        pyramidGeometry.materials = [materialPyr]
        
        pyramidNode.position = SCNVector3Make(0, -0.08, -0.2)
        sceneLocationView.pointOfView?.addChildNode(pyramidNode)
        
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        sceneLocationView.frame = view.bounds
    }
    
    func setupConstraints() {
        sceneLocationView.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        sceneLocationView.leadingAnchor == view.leadingAnchor
        sceneLocationView.trailingAnchor == view.trailingAnchor
        sceneLocationView.topAnchor == view.topAnchor
        
        topBar.topAnchor == view.topAnchor
        topBar.leadingAnchor == view.leadingAnchor
        topBar.trailingAnchor == view.trailingAnchor
        
        bottomBar.horizontalAnchors == view.horizontalAnchors
        bottomBar.bottomAnchor == view.bottomAnchor
        
        sideBar.leadingAnchor == view.leadingAnchor + 13
        sideBar.topAnchor == topBar.bottomAnchor + 40
        sideBar.bottomAnchor == bottomBar.topAnchor - 40
        sideBar.widthAnchor == 15
        
        map.widthAnchor == 190
        map.heightAnchor == 190
        map.topAnchor == topBar.bottomAnchor + 13
        map.trailingAnchor == view.trailingAnchor - 13
    }
    
    @objc func update() {
        guard let currentLocation = sceneLocationView.currentLocation() else {
            return
        }
        lastLocation = currentLocation
        let metersAway = lastLocation.distance(from: marked)
        
        guard let heading = sceneLocationView.locationManager.heading?.degreesToRadians else {
            return
        }
        
        let radians = lastLocation.bearingToLocationRadian(marked)
        
        rotate(x: pyramidNode, rotateTo: -(radians - CGFloat(heading)))
    }
    
    func rotate(x: SCNNode, rotateTo: CGFloat) {
        let rot = SCNAction.rotateTo(x: 0, y: 0, z: rotateTo, duration: 0.3, usesShortestUnitArc: true)
        x.runAction(rot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ViewController {
    
    func getBigBox(image: UIImage) -> SCNNode {
        let box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = image
        
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 1, 0)
        return node
    }
}

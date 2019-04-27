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
    
    var timer: Timer!
    
    let pyramidGeometry = SCNPyramid(width: 0.01, height: 0.02, length: 0.0108)
    lazy var pyramidNode = SCNNode(geometry: self.pyramidGeometry)
    
    var marked = CLLocation(latitude: 32.8855781716564785, longitude: -117.23935240809809)
    var lastLocation = CLLocation(latitude: 32.8855781716564785, longitude: -117.23935240809809)
    var lastX = 0.0
    
    var waypoints = [Waypoint]()
    
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table Codes
        let exit = self.getBigBox(image: UIImage.init(named: "Tile")!)
        exit.position = SCNVector3(-32, 1, -45)
        self.sceneLocationView.scene.rootNode.addChildNode(exit)
        let exitWaypoint = Waypoint(name: "Exit", latitude: 32.88580559622921, longitude: -117.2395439592874, altitude: 123.15)
        self.waypoints.append(exitWaypoint)
        
        let elevator = self.getBigBox(image: UIImage.init(named: "Tile")!)
        elevator.position = SCNVector3(-20, 1, -30)
        self.sceneLocationView.scene.rootNode.addChildNode(elevator)
        let elevatorWaypoint = Waypoint(name: "Elevator", latitude: 32.88605641907343, longitude: -117.23952412679434, altitude: 123.15)
        self.waypoints.append(elevatorWaypoint)
        
        let bathroom = self.getBigBox(image: UIImage.init(named: "Tile")!)
        bathroom.position = SCNVector3(-15, 1, -40)
        self.sceneLocationView.scene.rootNode.addChildNode(bathroom)
        let bathroomWaypoint = Waypoint(name: "Bathroom", latitude: 32.88632847330899, longitude: -117.23952955036582, altitude: 123.15)
        self.waypoints.append(bathroomWaypoint)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        sceneLocationView.run()
        
        topBar.instructionLabel.text = "Turn right on Broadway Ave"
        topBar.distanceLabel.text = "69 Feet"
        
        bottomBar.destinationLabel.text = "Joe's Magic Coffee"
        bottomBar.timeLabel.text = "About 10 min away"
        
        view.addSubview(sceneLocationView)
        view.addSubview(topBar)
        view.addSubview(bottomBar)
        
        // Make Pyramid
        let materialPyr = SCNMaterial()
        materialPyr.diffuse.contents = UIImage.init(named: "gradient")
        pyramidGeometry.materials = [materialPyr]
        
        self.pyramidNode.position = SCNVector3Make(0, -0.08, -0.2)
        self.sceneLocationView.pointOfView?.addChildNode(pyramidNode)
        
        self.setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        sceneLocationView.frame = view.bounds
    }
    
    func setupConstraints() {
        self.sceneLocationView.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor
        self.sceneLocationView.leadingAnchor == self.view.leadingAnchor
        self.sceneLocationView.trailingAnchor == self.view.trailingAnchor
        self.sceneLocationView.topAnchor == self.view.topAnchor
        
        topBar.topAnchor == view.topAnchor
        topBar.leadingAnchor == view.leadingAnchor
        topBar.trailingAnchor == view.trailingAnchor
        
        bottomBar.horizontalAnchors == view.horizontalAnchors
        bottomBar.bottomAnchor == view.bottomAnchor
    }
    
    @objc func update() {
        guard let currentLocation = self.sceneLocationView.currentLocation() else {
            return
        }
        self.lastLocation = currentLocation
        let metersAway = lastLocation.distance(from: marked)
        
        guard let heading = self.sceneLocationView.locationManager.heading?.degreesToRadians else {
            return
        }
        
        let radians = self.lastLocation.bearingToLocationRadian(self.marked)
        
        self.rotate(x: self.pyramidNode, rotateTo: -(radians - CGFloat(heading)))
    }
    
    func rotate(x: SCNNode, rotateTo: CGFloat) {
        let rot = SCNAction.rotateTo(x: 0, y: 0, z: rotateTo, duration: 0.3, usesShortestUnitArc: true)
        x.runAction(rot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

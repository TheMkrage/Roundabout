//
//  CompanionMapView.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class CompanionMapView: UIView {

    var mapView: MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.showsUserLocation = true
        return m
    }()
    
    var polyLine: MKPolyline = {
        let p = MKPolyline()
        return p
    }()
    
    var lineView: MKPolylineView = {
        let l = MKPolylineView()
        return l
    }()
    
    var locationManager: CLLocationManager?
    let distanceSpan: Double = 500
    var waypoints: [Waypoint]
    
    var didSetConstraints = false
    
    init(waypoints: [Waypoint]) {
        self.waypoints = waypoints
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.waypoints = []
        super.init(coder: aDecoder)
        initialize()
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
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        
        requestLocationAccess()
        addSubview(mapView)
        
        let location = CLLocationCoordinate2D(latitude: 9.6247279999999993,longitude: 46.170966100000001)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
        
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let arrayOfLatlong = [
            [34.106083, -117.710472],
            [34.105336, -117.713148],
            [34.105372, -117.710123],
            [34.106083, -117.710472]
        ]
        var coordinateArray = [CLLocationCoordinate2D]()
        for obj in arrayOfLatlong {
            let lat1 = obj[0]
            let lon1 = obj[1]
            let coordinate = CLLocationCoordinate2DMake(lat1, lon1);
            coordinateArray.append(coordinate)
        }
        polyLine = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        mapView.visibleMapRect = polyLine.boundingMapRect
        //If you want the route to be visible
        mapView.addOverlay(polyLine)
        
        locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
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
}

extension CompanionMapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let newLocation = locations.first else {
            return
        }
        let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
    }
}

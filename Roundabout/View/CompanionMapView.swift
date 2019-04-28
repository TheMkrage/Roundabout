//
//  CompanionMapView.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

protocol CompanionMapDelegate: class {
    func updated(location: CLLocation)
    func direction(step: MKRoute.Step)
}

class CompanionMapView: UIView {

    weak var delegate: CompanionMapDelegate?
    lazy var mapView: MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.showsUserLocation = true
        m.delegate = self
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
    let distanceSpan: Double = 1500
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
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
        
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        var arrayOfLatlong = [[Double]]()
        for waypoint in waypoints {
            arrayOfLatlong.append([waypoint.latitude, waypoint.longitude])
            
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = waypoint.name
            mapView.addAnnotation(annotation)
        }
        
        var coordinateArray = [CLLocationCoordinate2D]()
        for obj in arrayOfLatlong {
            let lat1 = obj[0]
            let lon1 = obj[1]
            let coordinate = CLLocationCoordinate2DMake(lat1, lon1);
            coordinateArray.append(coordinate)
        }
        
        var hasSentStep = false
        for i in 0..<coordinateArray.count - 1 {
            let src = coordinateArray[i]
            let dst = coordinateArray[i + 1]
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: src))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: dst))
            directionRequest.requestsAlternateRoutes = false
            directionRequest.transportType = .walking
            
            let direction = MKDirections(request: directionRequest)
            direction.calculate { (response, error) in
                guard let route = response?.routes.first else {
                    return
                }
                for step in route.steps {
                    if step.instructions != "" && !hasSentStep {
                        self.delegate?.direction(step: step)
                        hasSentStep = true
                    }
                }
                
                self.mapView.addOverlay(route.polyline)
            }
        }
        
        locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
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
        delegate?.updated(location: newLocation)
        let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //print("newHEADING: \(newHeading)")
    }
}

extension CompanionMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.init(named: "health")
            polylineRenderer.lineWidth = 2.0
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = MKMarkerAnnotationView()
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "a")
        return annotationView
    }
}

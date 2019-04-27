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
    
    let locationManager = CLLocationManager()
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func initialize() {
        requestLocationAccess()
        addSubview(mapView)
        
        let location = CLLocationCoordinate2D(latitude: 9.6247279999999993,longitude: 46.170966100000001)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let arrayOfLatlong = [
            [9.6247279999999993, 46.170966100000001],
            [9.6244014, 46.171050399999999],
            [9.6240834999999993, 46.171273900000003],
            [9.6240570000000005, 46.171284999999997]
        ]
        var coordinateArray = [CLLocationCoordinate2D]()
        for obj in arrayOfLatlong {
            let lat1 = obj[0]
            let lon1 = obj[1]
            let coordinate = CLLocationCoordinate2DMake(lat1, lon1);
            coordinateArray.append(coordinate)
        }
        polyLine = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        //mapView.visibleMapRect = polyLine.boundingMapRect
        //If you want the route to be visible
        //mapView.addOverlay(polyLine)
    }

}

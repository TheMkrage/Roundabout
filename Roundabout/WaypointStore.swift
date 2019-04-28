//
//  WaypointStore.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/27/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WaypointStore: NSObject {
    static let shared = WaypointStore()
    
    private override init() {
        
    }
    
    func get(categories: [String], startingPoint: CLLocationCoordinate2D, distance: Double, callback: (([Waypoint]) -> Void)) {
        /*var dictionary = Dictionary<String, Any>()
        var categoriesString = ""
        for x in categories {
            categoriesString.append("\(x),")
        }
        dictionary["categories"] = categoriesString
        dictionary["distance"] = distance
        dictionary["startingPointLat"] = startingPoint.latitude
        dictionary["startingPointLong"] = startingPoint.longitude
        
        Alamofire.request("https://fdasfas.com/", method: .get, parameters: dictionary, encoding: URLEncoding.default, headers: nil)*/
        
        var waypoints = [Waypoint]()
        
        let w1 = Waypoint(name: "Start", latitude: 34.106083, longitude: -117.710472, altitude: 0, percent: 0)
        let w2 = Waypoint(name: "Alfredo Coffee", latitude: 34.105336, longitude: -117.713148, altitude: 0, percent: 0)
        let w3 = Waypoint(name: "KRafdasfa dfsa fdsa fds fsd f sdfdsaf ger", latitude: 34.105372, longitude: -117.710123, altitude: 0, percent: 0)
        let w4 = Waypoint(name: "Start", latitude: 34.106083, longitude: -117.710472, altitude: 0, percent: 0)
        waypoints.append(w1)
        waypoints.append(w2)
        waypoints.append(w3)
        waypoints.append(w4)
        callback(waypoints)
    }
}

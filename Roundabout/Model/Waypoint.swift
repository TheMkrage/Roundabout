//
//  Waypoint.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation

class Waypoint: Decodable {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var altitude: CLLocationDistance
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDegrees) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}


//
//  Extensions.swift
//  Roundabout
//
//  Created by Matthew Krager on 4/26/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation
import Tags

extension TagButton {
    func setSelected() {
        var options = ButtonOptions(
            layerColor: UIColor.init(named: "health")!, // layer Color
            layerRadius: 12.0, // layer Radius
            layerWidth: 1.0, // layer Width
            tagTitleColor: UIColor.white, // title Color
            tagFont: UIFont(name: "HelveticaNeue", size: 16.0)!, // Font
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
        tagFont: UIFont(name: "HelveticaNeue", size: 16.0)!,
        tagBackgroundColor: UIColor.init(named: "tag")!, // Background Color
        lineBreakMode: NSLineBreakMode.byCharWrapping //break Mode,
    )
    
    func setUnselected() {
        TagButton.unselectedOptions.paddingHorizontal = 12.0
        TagButton.unselectedOptions.paddingVertical = 7.0
        setEntity(TagButton.unselectedOptions)
    }
}

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CLLocation {
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
        
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        
        let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
        let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing)
    }
    
    func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
        return bearingToLocationRadian(destinationLocation).radiansToDegrees
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

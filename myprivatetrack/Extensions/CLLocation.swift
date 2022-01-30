/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLLocation{
    
    func toString() -> String{
        "lat: \(coordinate.latitude), lon: \(coordinate.longitude), acc: \(horizontalAccuracy), speed: \(speed), course: \(course), time: \(timestamp.timestampString())"
    }
    
}

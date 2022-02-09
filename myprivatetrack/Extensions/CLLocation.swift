/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation

extension CLLocation{
    
    func toString() -> String{
        "lat: \(coordinate.latitude), lon: \(coordinate.longitude), acc: \(horizontalAccuracy), speed: \(speed), course: \(course), time: \(timestamp.timestampString())"
    }
    
}

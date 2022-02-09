/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import MapKit

extension MKMapView {
    
    func centerToLocation(_ location: Location, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    func findAttributionLabel() -> UIView?{
        for vw in subviews{
            if "\(vw.classForCoder)" == "MKAttributionLabel" {
                return vw
            }
        }
        return nil
    }
}

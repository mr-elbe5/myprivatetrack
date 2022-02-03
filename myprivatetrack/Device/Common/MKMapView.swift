//
//  MKMapView.swift
//
//  Created by Michael Rönnau on 10.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

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

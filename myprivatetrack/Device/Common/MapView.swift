//
//  MapView.swift
//
//  Created by Michael Rönnau on 10.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapboxMaps

extension MapView {
    
    func centerToLocation(_ coordinate: CLLocationCoordinate2D, zoom: CGFloat = Settings.shared.mapStartZoom) {
        camera.ease(
        to: CameraOptions(center: coordinate, zoom: zoom),
        duration: 1.3)
    }
    
    func centerToLocation(latitude: Double, longitude: Double, zoom: CGFloat = Settings.shared.mapStartZoom) {
        camera.ease(
        to: CameraOptions(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: zoom),
        duration: 1.3)
    }
    
}

//
//  CameraLocationConsumer.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 14.07.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import UIKit
import MapboxMaps

public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?

    init(mapView: MapView) {
        self.mapView = mapView
    }

    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 15),
            duration: 1.3)
    }
}

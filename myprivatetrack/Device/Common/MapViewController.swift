//
//  MapViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.07.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapboxMaps
import SwiftyIOSViewExtensions

class MapViewController: UIViewController, LocationConsumer {
    
    var headerView = UIView()
    var mapView : MapView!
    var mapLoaded = false
    var location: Location? = nil
    var startZoom : CGFloat{
        get{
            Settings.shared.mapStartZoom
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let coordinate = LocationService.shared.lastLocation?.coordinate{
            mapView.camera.ease(
                to: CameraOptions(center: coordinate, zoom: startZoom),
                duration: 0.0)
            location = Location(with: LocationService.shared.lastLocation!)
        }
    }
    
    func locationUpdate(newLocation: Location) {
        if location == nil{
            mapView.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: startZoom), duration: 0.5)
            location = newLocation
        }
    }
    
    @objc func toggleMapStyle() {
        if mapView.mapboxMap.style.uri == .satellite{
            mapView.mapboxMap.style.uri = .streets
        }
        else{
            mapView.mapboxMap.style.uri = .satellite
        }
    }
    
    @objc func showInfo(){
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}


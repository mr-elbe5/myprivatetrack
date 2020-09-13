//
//  Location.swift
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate{
    func locationDidChange(location: Location)
}

class LocationService : NSObject, CLLocationManagerDelegate{
    
    static var shared = LocationService()
    // min location difference in meters
    static var deviation : CLLocationDistance = 5
    
    var clLocation : CLLocation? = nil
    var placemark : CLPlacemark? = nil
    var running = false
    var delegate : LocationServiceDelegate? = nil
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var authorized : Bool{
        get{
            return CLLocationManager.authorized
        }
    }
    
    func getLocation() -> Location? {
        return clLocation == nil ? nil : Location(clLocation!)
    }
    
    func getLocationDescription() -> String {
        var s = ""
        if let place = placemark{
            if let name = place.name{
                s += name
            }
            if let locality = place.locality{
                if !s.isEmpty{
                    s += ", "
                }
                s += locality
            }
        }
        return s
    }
    
    func lookUpCurrentLocation() {
        if let lastLocation = clLocation {
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    self.placemark = placemarks?[0]
                }
            })
        }
    }
    
    func start(){
        if authorized{
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    func checkRunning(){
        if authorized && !running{
            //print("run after check")
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    func stop(){
        if running{
            locationManager.stopUpdatingLocation()
        }
    }
    
    func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if clLocation == nil || newLocation.distance(from: clLocation!) > LocationService.deviation{
            clLocation = newLocation
            lookUpCurrentLocation()
            if let delegate = delegate{
                delegate.locationDidChange(location: Location(clLocation!))
                
            }
        }
    }
    
}


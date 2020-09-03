//
//  Location.swift
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationServiceDelegate{
    func locationDidChange(location: Location)
}

public class LocationService : NSObject, CLLocationManagerDelegate{
    
    public static var shared = LocationService()
    public static var deviation : Double = 0.0001
    
    public var clLocation : CLLocation? = nil
    public var placemark : CLPlacemark? = nil
    public var running = false
    public var delegate : LocationServiceDelegate? = nil
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public var authorized : Bool{
        get{
            return CLLocationManager.authorized
        }
    }
    
    public func getLocation() -> Location? {
        return clLocation == nil ? nil : Location(clLocation!)
    }
    
    public func getLocationDescription() -> String {
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
    
    public func start(){
        if authorized{
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    public func checkRunning(){
        if authorized && !running{
            //print("run after check")
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    public func stop(){
        if running{
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if clLocation == nil || newLocation.distance(from: clLocation!) > 5{
            clLocation = newLocation
            lookUpCurrentLocation()
            if let delegate = delegate{
                delegate.locationDidChange(location: Location(clLocation!))
                
            }
        }
    }
    
}


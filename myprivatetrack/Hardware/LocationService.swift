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
    public var running = false
    public var delegate : LocationServiceDelegate? = nil
    
    private let locationManager = CLLocationManager()
    
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
    
    public func start(){
        if authorized{
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    public func checkRunning(){
        if authorized && !running{
            print("run after check")
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
        if !running{
            print("i am running!")
            running = true
        }
        guard let newLocation = locations.last else { return }
        if clLocation == nil || newLocation.distance(from: clLocation!) > 5{
            clLocation = newLocation
            if let delegate = delegate{
                delegate.locationDidChange(location: Location(clLocation!))
            }
        }
    }
    
}


//
//  Location.swift
//  E5Data
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationDelegate{
    func loctionDidChange(coordinate: CLLocationCoordinate2D)
}

public class LocationService : NSObject, CLLocationManagerDelegate{
    
    public static var shared = LocationService()
    public static var deviation : Double = 0.0001
    
    public var location = CLLocation()
    public var active = false
    public var delegate : LocationDelegate? = nil
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public var authorized : Bool{
        get{
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                return true
            case.authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
    }
    
    public func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func assertRunning(){
        if !active{
            startUpdatingLocation()
            if !LocationService.shared.active{
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.startUpdatingLocation()
                    if !LocationService.shared.active{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self.startUpdatingLocation()
                        }
                    }
                }
            }
        }
    }
    
    public func startUpdatingLocation(){
        if !authorized {
            active = false
            return
        }
        if !active{
            locationManager.startUpdatingLocation()
            active = true
        }
    }
    
    public func stopUpdatingLocation(){
        if active {
            locationManager.stopUpdatingLocation()
            active = false
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if location.differs(from: newLocation, byMoreThan: LocationService.deviation){
            location = newLocation
            if let delegate = delegate{
                delegate.loctionDidChange(coordinate: location.coordinate)
            }
        }
    }
    
}


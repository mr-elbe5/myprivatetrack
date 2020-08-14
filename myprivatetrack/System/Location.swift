//
//  Location.swift
//  test.ios
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDelegate{
    func loctionDidChange(coordinate: CLLocationCoordinate2D)
}

class Location : NSObject, CLLocationManagerDelegate{
    
    static var shared = Location()
    static var deviation : Double = 0.0001
    
    var coordinate = CLLocationCoordinate2D()
    var active = false
    var delegate : LocationDelegate? = nil
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var authorized : Bool{
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
    
    func requestWhenInUseAuthorization(){
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func assertRunning(){
        if !active{
            startUpdatingLocation()
            if !Location.shared.active{
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.startUpdatingLocation()
                    if !Location.shared.active{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self.startUpdatingLocation()
                        }
                    }
                }
            }
        }
    }
    
    func startUpdatingLocation(){
        if !authorized {
            active = false
            return
        }
        if !active{
            locationManager.startUpdatingLocation()
            active = true
        }
    }
    
    func stopUpdatingLocation(){
        if active {
            locationManager.stopUpdatingLocation()
            active = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if abs(coordinate.latitude - location.coordinate.latitude) > Location.deviation{
            coordinate = location.coordinate
            if let delegate = delegate{
                delegate.loctionDidChange(coordinate: coordinate)
            }
        }
    }
    
}


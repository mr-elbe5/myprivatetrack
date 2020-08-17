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

class LocationService : NSObject, CLLocationManagerDelegate{
    
    static var shared = LocationService()
    static var deviation : Double = 0.0001
    
    var location = CLLocation()
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
        if DataStore.shared.settings.useLocation && !active{
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
        guard let newLocation = locations.last else { return }
        if location.differs(from: newLocation, byMoreThan: LocationService.deviation){
            location = newLocation
            if let delegate = delegate{
                delegate.loctionDidChange(coordinate: location.coordinate)
            }
        }
    }
    
}


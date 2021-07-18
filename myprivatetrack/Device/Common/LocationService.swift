//
//  Location.swift
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation
import MapboxMaps

protocol LocationServiceDelegate{
    func locationsDidChange(locations: [CLLocation])
    func headingDidChange(heading: CLHeading)
    func failedWithError(error: Error)
    func authorizationDidChange(manager: CLLocationManager)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static var shared = LocationService()
    
    let locationManager = CLLocationManager()
    var locationOptions: LocationOptions {
        didSet {
            locationManager.distanceFilter = locationOptions.distanceFilter
            locationManager.desiredAccuracy = locationOptions.desiredAccuracy
            locationManager.activityType = locationOptions.activityType
        }
    }
    let geocoder = CLGeocoder()
    var lastLocation: CLLocation? = nil
    var placemark : CLPlacemark? = nil
    
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    var accuracyAuthorization: CLAccuracyAuthorization {
        if #available(iOS 14.0, *) {
            return locationManager.accuracyAuthorization
        } else {
            return .fullAccuracy
        }
    }
    
    var entriesDelegate : LocationServiceDelegate? = nil
    var captureDelegate : LocationServiceDelegate? = nil
    
    override init() {
        locationOptions = LocationOptions()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation(){
        if authorizationStatus == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
    }

    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
    }
    
    func lookUpCurrentLocation() {
        if let location = lastLocation{
            geocoder.reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), completionHandler: { (placemarks, error) in
                if error == nil {
                    self.placemark = placemarks?[0]
                }
            })
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty{
            lastLocation = locations.last
        }
        entriesDelegate?.locationsDidChange(locations: locations)
        captureDelegate?.locationsDidChange(locations: locations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        entriesDelegate?.headingDidChange(heading: heading)
        captureDelegate?.headingDidChange(heading: heading)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        entriesDelegate?.failedWithError(error: error)
        captureDelegate?.failedWithError(error: error)
    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        entriesDelegate?.authorizationDidChange(manager: locationManager)
        captureDelegate?.authorizationDidChange(manager: locationManager)
    }
    
}


//
//  MapLocationProvider.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 14.07.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation
import MapboxMaps

public class MapLocationProvider: NSObject {
    
    private var name : String
    private weak var delegate: LocationProviderDelegate?

    public init(name: String) {
        self.name = name
        super.init()
        LocationService.shared.setDelegate(name: name, delegate: self)
    }
    
    deinit{
        LocationService.shared.removeDelegate(name: name)
    }
}

extension MapLocationProvider: LocationProvider {

    public var locationProviderOptions: LocationOptions {
        get {
            return LocationService.shared.locationOptions
        }
        set {
            LocationService.shared.locationOptions = newValue
        }
    }

    public var authorizationStatus: CLAuthorizationStatus {
        LocationService.shared.authorizationStatus
    }

    public var accuracyAuthorization: CLAccuracyAuthorization {
        return LocationService.shared.accuracyAuthorization
    }

    public var heading: CLHeading? {
        return LocationService.shared.locationManager.heading
    }

    public func setDelegate(_ delegate: LocationProviderDelegate) {
        self.delegate = delegate
    }

    public func requestAlwaysAuthorization() {
        LocationService.shared.requestAlwaysAuthorization()
    }

    public func requestWhenInUseAuthorization() {
        LocationService.shared.requestWhenInUseAuthorization()
    }

    @available(iOS 14.0, *)
    public func requestTemporaryFullAccuracyAuthorization(withPurposeKey purposeKey: String) {
        LocationService.shared.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
    }

    public func startUpdatingLocation() {
        LocationService.shared.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        LocationService.shared.stopUpdatingLocation()
    }

    public var headingOrientation: CLDeviceOrientation {
        set {
            LocationService.shared.locationManager.headingOrientation = newValue
        } get {
            return LocationService.shared.locationManager.headingOrientation
        }
    }

    public func startUpdatingHeading() {
        LocationService.shared.startUpdatingHeading()
    }

    public func stopUpdatingHeading() {
        LocationService.shared.stopUpdatingHeading()
    }

    public func dismissHeadingCalibrationDisplay() {
        LocationService.shared.locationManager.dismissHeadingCalibrationDisplay()
    }
}

extension MapLocationProvider: LocationServiceDelegate {
    func locationsDidChange(locations: [CLLocation]) {
        delegate?.locationProvider(self, didUpdateLocations: locations)
    }
    
    func headingDidChange(heading: CLHeading) {
        delegate?.locationProvider(self, didUpdateHeading: heading)
    }
    
    func failedWithError(error: Error) {
        delegate?.locationProvider(self, didFailWithError: error)
    }
    
    func authorizationDidChange(manager: CLLocationManager) {
        delegate?.locationProviderDidChangeAuthorization(self)
    }

}

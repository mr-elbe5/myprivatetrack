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

class MapLocationProvider: NSObject {
    
    private var name : String
    private weak var delegate: LocationProviderDelegate?

    init(name: String) {
        self.name = name
        super.init()
        LocationService.shared.setDelegate(name: name, delegate: self)
    }
    
    deinit{
        LocationService.shared.removeDelegate(name: name)
    }
}

extension MapLocationProvider: LocationProvider {

    var locationProviderOptions: LocationOptions {
        get {
            return LocationService.shared.locationOptions
        }
        set {
            LocationService.shared.locationOptions = newValue
        }
    }

    var authorizationStatus: CLAuthorizationStatus {
        LocationService.shared.authorizationStatus
    }

    var accuracyAuthorization: CLAccuracyAuthorization {
        return LocationService.shared.accuracyAuthorization
    }

    var heading: CLHeading? {
        return LocationService.shared.locationManager.heading
    }

    func setDelegate(_ delegate: LocationProviderDelegate) {
        self.delegate = delegate
    }

    func requestAlwaysAuthorization() {
        LocationService.shared.requestAlwaysAuthorization()
    }

    func requestWhenInUseAuthorization() {
        LocationService.shared.requestWhenInUseAuthorization()
    }

    @available(iOS 14.0, *)
    func requestTemporaryFullAccuracyAuthorization(withPurposeKey purposeKey: String) {
        LocationService.shared.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
    }

    func startUpdatingLocation() {
        LocationService.shared.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        LocationService.shared.stopUpdatingLocation()
    }

    var headingOrientation: CLDeviceOrientation {
        set {
            LocationService.shared.locationManager.headingOrientation = newValue
        } get {
            return LocationService.shared.locationManager.headingOrientation
        }
    }

    func startUpdatingHeading() {
        LocationService.shared.startUpdatingHeading()
    }

    func stopUpdatingHeading() {
        LocationService.shared.stopUpdatingHeading()
    }

    func dismissHeadingCalibrationDisplay() {
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

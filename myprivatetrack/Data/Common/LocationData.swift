//
//  Location.swift
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import MapboxMaps
import CoreLocation

class LocationData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
    }
    
    var coordinate: CLLocationCoordinate2D
    var altitude: Double
    var placemark : CLPlacemark? = nil
    
    init(){
        coordinate = CLLocationCoordinate2D()
        altitude = 0
    }
    
    init(latitude: Double, longitude: Double, altitude: Double = 0){
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.altitude = altitude
    }
    
    var asString : String{
        get{
            let latitudeText = coordinate.latitude > 0 ? "north".localize() : "south".localize()
            let longitudeText = coordinate.longitude > 0 ? "east".localize() : "west".localize()
            return String(format: "%.04f", abs(coordinate.latitude)) + "° " + latitudeText + ", " + String(format: "%.04f", abs(coordinate.longitude)) + "° "  + longitudeText
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let latitude = try values.decodeIfPresent(Double.self, forKey: .latitude), let longitude = try values.decodeIfPresent(Double.self, forKey: .longitude){
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        else{
            coordinate = CLLocationCoordinate2D()
        }
        altitude = try values.decodeIfPresent(Double.self, forKey: .altitude) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
    }
    
    func lookUpCurrentLocation() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { (placemarks, error) in
            if error == nil {
                self.placemark = placemarks?[0]
            }
        })
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
    
}


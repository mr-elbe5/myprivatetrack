//
//  Location.swift
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

class Location: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
    }
    
    public var coordinate: CLLocationCoordinate2D
    public var altitude: Double
    
    init(){
        coordinate = CLLocationCoordinate2D()
        altitude = 0.0
    }
    
    init(_ location: CLLocation){
        self.coordinate = location.coordinate
        self.altitude = location.altitude
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        altitude = try values.decode(Double.self, forKey: .altitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
    }
    
}

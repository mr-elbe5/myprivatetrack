//
//  CLLocation.swift
//  E5Data
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation{
    
    public func differs(from newLocation: CLLocation, byMoreThan maxDiff: Double) -> Bool{
        return abs(coordinate.latitude - newLocation.coordinate.latitude) > maxDiff || abs(coordinate.longitude - newLocation.coordinate.longitude) > maxDiff
    }
    
}

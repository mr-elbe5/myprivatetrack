//
//  EntryAnnotation.swift
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EntryAnnotation : MKPointAnnotation{
    
    var entry : EntryData
    
    init(entry: EntryData){
        self.entry = entry
    }
}

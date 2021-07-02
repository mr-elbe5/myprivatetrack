//
//  MapboxViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 02.07.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapboxMaps

class MapboxViewController : UIViewController{
    
    internal var mapView: MapView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        print(view.bounds)
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(mapView)
    }
    
    
}

//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MainMapViewController: MapViewController, LocationServiceDelegate {
    
    var location: Location? = nil
    var radius : CLLocationDistance = 10000
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func fillHeaderView(){
        super.fillHeaderView()
        let infoButton = IconButton(icon: "info.circle", tintColor: .white)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
    }
    
    func locationDidChange(location: Location){
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: self.radius)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationService.shared.authorized{
            if location == nil{
                location = LocationService.shared.getLocation()
                if let loc = location{
                    self.mkMapView.centerToLocation(loc, regionRadius: self.radius)
                }
            }
            LocationService.shared.delegate = self
        }
        else{
            showError("locationNotAuthorized")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            mkMapView.removeAnnotations(mkMapView.annotations)
            assertMapPins()
        }
    }
    
    override func assertMapPins(){
        for day in GlobalData.shared.days{
            for entry in day.entries{
                if entry.saveLocation, let loc = entry.location{
                    let positionPin = EntryAnnotation(entry: entry)
                    positionPin.title = entry.creationDate.dateTimeString()
                    positionPin.coordinate = loc.coordinate
                    mkMapView.addAnnotation(positionPin)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let annotation = view.annotation as? EntryAnnotation{
            let entryController = EntryViewController()
            entryController.entry = annotation.entry
            entryController.modalPresentationStyle = .fullScreen
            self.present(entryController, animated: true)
        }
    }
    
    @objc func showInfo(){
        let infoController = MapInfoViewController()
        self.present(infoController, animated: true)
    }
    
}

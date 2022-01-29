//
//  LocationCaptureViewController.swift
//
//  Created by Michael Rönnau on 23.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol MapCaptureDelegate{
    func mapCaptured(data: MapPhotoItemData)
}

class MapCaptureViewController: MapViewController, LocationServiceDelegate {
    
    var location : Location? = nil
    var radius : CLLocationDistance = Settings.shared.mapStartSize.rawValue
    var positionPin : MKPointAnnotation? = nil
    
    var captureDelegate: MapCaptureDelegate? = nil
    
    var captureButton = CaptureButton()
    
    override func loadView() {
        self.modalPresentationStyle = .fullScreen
        super.loadView()
        LocationService.shared.checkRunning()
        if let loc = LocationService.shared.getLocation(){
            setLocation(location: loc)
        }
        captureButton.addTarget(self, action: #selector(save), for: .touchDown)
        mkMapView.addSubview(captureButton)
        captureButton.isEnabled = false
        captureButton.setAnchors(bottom: mkMapView.bottomAnchor, insets: defaultInsets)
            .centerX(mkMapView.centerXAnchor)
            .width(50)
            .height(50)
    }
    
    override func fillHeaderView(){
        super.fillHeaderView()
        let closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
        closeButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
        captureButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func locationDidChange(location: Location){
        setLocation(location: location)
    }
    
    @objc func save(){
        Indicator.shared.show()
        if let image = takeScreenshot(){
            let mapItem = MapPhotoItemData()
            mapItem.creationDate = Date()
            mapItem.saveImage(uiImage: image)
            mapItem.title = ""
            self.captureDelegate?.mapCaptured(data: mapItem)
            Indicator.shared.hide()
            self.dismiss(animated: true)
        }
        else{
            print("error while taking screenshot")
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
    func setLocation(location : Location){
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: radius)
        }
        self.location = location
        if let pin = positionPin{
            pin.coordinate = location.coordinate
        }
            
    }
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let identifier = "userPosition"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(
        withIdentifier: identifier) as? MKPinAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      }
      return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
        
    }
    
    override func assertMapPins() {
        if positionPin == nil{
            positionPin = MKPointAnnotation()
            positionPin!.title = "yourPosition".localize()
            positionPin!.coordinate = mkMapView.centerCoordinate
            mkMapView.addAnnotation(positionPin!)
        }
        
    }
    
    func takeScreenshot() -> UIImage?{
        var image : UIImage? = nil
        captureButton.isHidden = true
        UIGraphicsBeginImageContext(mkMapView.bounds.size)
        if let ctx = UIGraphicsGetCurrentContext(){
            mkMapView.layer.render(in: ctx)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        captureButton.isHidden = false
        return image
    }
    
    private func drawPin(point: CGPoint, annotation: MKAnnotation) {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "snapshotUserPosition")
        annotationView.contentMode = .scaleAspectFit
        annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        annotationView.drawHierarchy(in: CGRect(
            x: point.x - annotationView.bounds.size.width / 2.0,
            y: point.y - annotationView.bounds.size.height,
            width: annotationView.bounds.width,
            height: annotationView.bounds.height), afterScreenUpdates: true)
    }
    
}


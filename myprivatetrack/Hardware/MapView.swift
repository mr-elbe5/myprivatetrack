//
//  MapView.swift
//
//  Created by Michael Rönnau on 05.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol MapViewDelegate{
    func didFinishLoading()
}

class MapView : UIView, MKMapViewDelegate{
    
    private var mapView : MKMapView!
    
    var location : CLLocation? = nil
    var radius : CLLocationDistance = 1000
    
    var positionPin : MKPointAnnotation? = nil
    var delegate : MapViewDelegate? = nil
    
    var mapType : MKMapType{
        get{
            return mapView.mapType
        }
    }
    
    func setupView(){
        mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        addSubview(mapView)
    }
    
    func setLocation(coordinate : CLLocationCoordinate2D){
        location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.centerToLocation(location!, regionRadius: radius)
    }
    
    func toggleMapType(){
        if mapView.mapType == .satellite{
            mapView.mapType = .standard
        }
        else{
            mapView.mapType = .satellite
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        assertMapPin()
        delegate?.didFinishLoading()
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
    
    func assertMapPin() {
        if positionPin == nil{
            positionPin = MKPointAnnotation()
            positionPin!.title = "yourPosition".localize()
            positionPin!.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(positionPin!)
        }
        
    }
    
    func takeScreenshot(callback: @escaping (_ result: UIImage?) -> Void){
        let options = MKMapSnapshotter.Options()
        options.camera = self.mapView.camera
        options.region = self.mapView.region
        options.mapType = self.mapView.mapType
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if error != nil {
                print("Unable to create a map snapshot.")
                callback(nil)
            } else if let snapshot = snapshot, let coord = self.location?.coordinate {
                let pos = snapshot.point(for: coord)
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)
                if let pin = self.positionPin {
                    self.drawPin(point: pos, annotation: pin)
                }
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                callback(compositeImage)
            }
        }
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

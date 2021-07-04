//
//  MapView.swift
//
//  Created by Michael Rönnau on 05.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapboxMaps

class MapkitMapView : UIView{

    //todo
    /*private var mapView : MapView!
    
    var location : Location? = nil
    var radius : CLLocationDistance = Settings.shared.mapStartSize.rawValue
    
    var positionPin : PointAnnotation? = nil
    var delegate : MapViewDelegate? = nil
    
    var mapType : MapType{
        get{
            return mapView.mapType
        }
    }
    
    func setupView(){
        mapView = MapView()
        mapView.mapType = .satellite
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        addSubview(mapView)
    }
    
    func setLocation(location : Location){
        if self.location == nil{
            self.location = location
            mapView.centerToLocation(location, regionRadius: radius)
        }
        self.location = location
        if let pin = positionPin{
            pin.coordinate = location.coordinate
        }
            
    }
    
    func toggleMapType(){
        if mapView.mapType == .satellite{
            mapView.mapType = .standard
        }
        else{
            mapView.mapType = .satellite
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MapView) {
        assertMapPin()
        delegate?.didFinishLoading()
    }
    
    func mapView(_ mapView: MapView,viewFor annotation: Annotation) -> AnnotationView? {
      let identifier = "userPosition"
      var view: PinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(
        withIdentifier: identifier) as? PinAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        view = PinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      }
      return view
    }
    
    func mapView(_ mapView: MapView, didSelect view: AnnotationView){
        
    }
    
    func mapView(_ mapView: MapView, didDeselect view: MKAnnotationView){
        
    }
    
    func assertMapPin() {
        if positionPin == nil{
            positionPin = MKPointAnnotation()
            positionPin!.title = "yourPosition".localize()
            positionPin!.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(positionPin!)
        }
        
    }
    
    func takeScreenshot(callback: @escaping (Result<UIImage, MapError>) -> Void){
        let options = MKMapSnapshotter.Options()
        options.camera = self.mapView.camera
        options.region = self.mapView.region
        options.mapType = self.mapView.mapType
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if error != nil {
                print("Unable to create a map snapshot.")
                callback(.failure(.snapshot))
            } else if let snapshot = snapshot, let coord = self.location?.coordinate {
                let pos = snapshot.point(for: coord)
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)
                if let pin = self.positionPin {
                    self.drawPin(point: pos, annotation: pin)
                }
                if let compositeImage = UIGraphicsGetImageFromCurrentImageContext(){
                    callback(.success(compositeImage))
                }
                else{
                    callback(.failure(.snapshot))
                }
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
     */
    
}

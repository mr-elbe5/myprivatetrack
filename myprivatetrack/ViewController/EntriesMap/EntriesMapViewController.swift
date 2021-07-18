//
//  MapViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapboxMaps
import SwiftyIOSViewExtensions

class EntriesMapViewController: MapViewController, AnnotationInteractionDelegate {
    
    var annotationsManager : PointAnnotationManager!
    var zoom : CGFloat = Settings.shared.mapStartZoom
    
    override func configureMapView(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.overrideLocationProvider(with: MapLocationProvider(name: "mapview"))
        mapView.location.options.puckType = .puck2D()
        mapView.location.addLocationConsumer(newConsumer: self)
        annotationsManager = mapView.annotations.makePointAnnotationManager()
        annotationsManager.delegate = self
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.mapLoaded = true
            self.mapView.location.addLocationConsumer(newConsumer: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEntryPins()
    }
    
    override func locationUpdate(newLocation: Location) {
        if location == nil{
            print("location at update")
            mapView.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: zoom), duration: 0.5)
            location = newLocation
        }
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            removeEntryPins()
            setEntryPins()
            if let location = location{
                mapView.centerToLocation(location.coordinate, zoom: self.zoom)
            }
        }
    }
    
    func removeEntryPins(){
        annotationsManager.syncAnnotations([])
    }
    
    func setEntryPins(){
        var annotations = [PointAnnotation]()
        for day in globalData.days{
            for entry in day.entries{
                if entry.saveLocation, let loc = entry.location{
                    var positionPin = PointAnnotation(id: entry.id.uuidString, coordinate: loc.coordinate)
                    positionPin.image = .default
                    //positionPin.textField = entry.creationDate.dateTimeString()
                    annotations.append(positionPin)
                }
            }
        }
        if !annotations.isEmpty{
            annotationsManager.syncAnnotations(annotations)
        }
    }

    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        if let annotation = annotations.first{
            if let id = UUID(uuidString: annotation.id), let entry = globalData.getEntry(id: id){
                let entryController = EntryViewController()
                entryController.entry = entry
                entryController.modalPresentationStyle = .fullScreen
                self.present(entryController, animated: true)
            }
        }
    }
    
    @objc override func showInfo(){
        let infoController = EntriesMapInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func takeScreenshot(callback: @escaping (Result<UIImage, Error>) -> Void){
        /*let options = MKMapSnapshotter.Options()
        options.camera = self.mapView.camera
        options.region = self.mapView.region
        options.mapType = self.mapView.mapType
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if error != nil {
                print("Unable to create a map snapshot.")
                callback(.failure(error!))
            } else if let snapshot = snapshot {
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)
                self.drawPins()
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                callback(.success(compositeImage!))
            }
        }

         */
    }
    
}

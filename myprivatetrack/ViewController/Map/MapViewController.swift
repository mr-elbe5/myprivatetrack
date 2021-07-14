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

class MapViewController: UIViewController {
    
    var headerView = UIView()
    var mapView : MapView!
    var mapLoaded = false
    var location: Location? = nil
    var zoom : MapStartZoom = MapStartZoom.large
    
    internal var cameraLocationConsumer: CameraLocationConsumer!
    
    override func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(guide.topAnchor,inset: .zero)
            .trailing(guide.trailingAnchor,inset: .zero)
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        let toggleStyleButton = IconButton(icon: "map")
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.overrideLocationProvider(with: MapLocationProvider())
        view.addSubview(mapView)
        mapView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView.bottomAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)
        mapView.location.options.puckType = .puck2D()
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)
        }
    }
    
    func locationDidChange(location: Location){
        print("map loc = \(location.coordinate)")
        if self.location == nil{
            self.location = location
            mapView.centerToLocation(location.coordinate, zoom: self.zoom.rawValue)
        }
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            //mapView.removeAnnotations(mapView.annotations)
            assertMapPins()
            if let location = location{
                mapView.centerToLocation(location.coordinate, zoom: self.zoom.rawValue)
            }
        }
    }
    
    func assertMapPins(){
        for day in globalData.days{
            for entry in day.entries{
                /*
                if entry.saveLocation, let loc = entry.location{
                    let positionPin = EntryAnnotation(entry: entry)
                    positionPin.title = entry.creationDate.dateTimeString()
                    positionPin.coordinate = loc.coordinate
                    mapView.addAnnotation(positionPin)
                }

                 */
            }
        }
    }

    /*
    func mapView(_ mapView: MapView, didSelect view: MKAnnotationView){
        if let annotation = view.annotation as? EntryAnnotation{
            //print("entry = \(annotation.entry)")
            let entryController = EntryViewController()
            entryController.entry = annotation.entry
            entryController.modalPresentationStyle = .fullScreen
            self.present(entryController, animated: true)
        }
    }

     */

    
    @objc func toggleMapStyle() {
        if mapView.mapboxMap.style.uri == .satellite{
            mapView.mapboxMap.style.uri = .streets
        }
        else{
            mapView.mapboxMap.style.uri = .satellite
        }
    }
    
    @objc func showInfo(){
        let infoController = MapInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
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
    
    private func drawPins(){
        
    }
    
    /*
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

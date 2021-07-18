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
        let locationProvider = MapLocationProvider()
        LocationService.shared.entriesDelegate = locationProvider
        mapView.location.overrideLocationProvider(with: locationProvider)
        mapView.location.options.puckType = .puck2D()
        mapView.location.addLocationConsumer(newConsumer: self)
        annotationsManager = mapView.annotations.makePointAnnotationManager()
        annotationsManager.delegate = self
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.mapLoaded = true
            self.mapView.location.addLocationConsumer(newConsumer: self)
        }
        view.addSubview(mapView)
        mapView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView.bottomAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
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
    
}

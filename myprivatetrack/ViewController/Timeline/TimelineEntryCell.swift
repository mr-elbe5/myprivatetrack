//
//  EntryCell.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

protocol EntryCellActionDelegate{
    func editEntry(entry: EntryData)
    func deleteEntry(entry: EntryData)
    func viewEntry(entry: EntryData)
    func viewPhotoItem(data: PhotoData)
    func sharePhotoItem(data: PhotoData)
    func viewVideoItem(data: VideoData)
    func shareVideoItem(data: VideoData)
}

class TimelineEntryCell: UITableViewCell, PhotoItemDelegate, VideoItemDelegate{
    
    var entry : EntryData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: EntryCellActionDelegate? = nil
    
    var cellBody = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        cellBody.backgroundColor = transparentColor
        cellBody.layer.cornerRadius = 5
        contentView.addSubview(cellBody)
        cellBody.fillSuperview(insets: defaultInsets)
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.backgroundColor = transparentColor
        cellBody.removeAllSubviews()
        if entry != nil{
            let timeLabel = UILabel()
            timeLabel.text = entry!.creationDate.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.placeBelow(anchor: cellBody.topAnchor, insets: defaultInsets)
            var lastView : UIView = timeLabel
            if entry!.saveLocation, let loc = entry!.location{
                let locationButton = TextButton(text: loc.asString)
                locationButton.addTarget(self,action: #selector(showInMap), for: .touchDown)
                cellBody.addSubview(locationButton)
                locationButton.placeBelow(anchor: lastView.bottomAnchor, insets: defaultInsets)
                lastView = locationButton
                let desc = entry!.locationDescription
                if !desc.isEmpty{
                    let locationDescriptionLabel = UILabel()
                    locationDescriptionLabel.text = desc
                    locationDescriptionLabel.textAlignment = .center
                    cellBody.addSubview(locationDescriptionLabel)
                    locationDescriptionLabel.placeBelow(anchor: lastView.bottomAnchor, insets: defaultInsets)
                    lastView = locationDescriptionLabel
                }
                if entry!.hasMapSection{
                    let mapView = MapItemView()
                    mapView.setupView(data: entry!)
                    cellBody.addSubview(mapView)
                    mapView.placeBelow(view: lastView)
                    lastView = mapView
                }
            }
            if isEditing{
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editEntry), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.setAnchors()
                editButton.top(cellBody.topAnchor, inset: defaultInset)
                
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors()
                    .top(cellBody.topAnchor, inset: defaultInset)
                    .trailing(cellBody.trailingAnchor, inset: defaultInset)
                editButton.trailing(deleteButton.leadingAnchor, inset: defaultInset)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewEntry), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.placeTopRight(insets: doubleInsets)
            }
            
            for item in entry!.items{
                switch item.type{
                case .text:
                    let itemView = TextItemView.fromData(data: item.data as! TextData)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, insets: defaultInsets)
                    lastView = itemView
                    break
                case .audio:
                    let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, insets: defaultInsets)
                    lastView = itemView
                    break
                case .photo:
                    let itemView = PhotoItemView.fromData(data: item.data as! PhotoData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, insets: defaultInsets)
                    lastView = itemView
                    break
                case .video:
                    let itemView = VideoItemView.fromData(data: item.data as! VideoData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.placeBelow(view: lastView, insets: defaultInsets)
                    lastView = itemView
                    break
                }
            }
            lastView.connectBottom(view: cellBody, insets: defaultInset)
        }
    }
    
    @objc func showInMap(){
        if let location = entry?.location{
            let mapController = MainTabController.getMapViewController()
            mapController?.mkMapView.centerToLocation(location)
            MainTabController.instance.selectedViewController = mapController
        }
    }
    
    @objc func editEntry() {
        if entry != nil{
            delegate?.editEntry(entry: entry!)
        }
    }
    
    @objc func deleteEntry() {
        if entry != nil{
            delegate?.deleteEntry(entry: entry!)
        }
    }
    
    @objc func viewEntry(){
        if entry != nil{
            delegate?.viewEntry(entry: entry!)
        }
    }
    
    func viewPhotoItem(data: PhotoData){
        delegate?.viewPhotoItem(data: data)
    }
    
    func sharePhotoItem(data: PhotoData){
        delegate?.sharePhotoItem(data: data)
    }
    
    func viewVideoItem(data: VideoData){
        delegate?.viewVideoItem(data: data)
    }
    
    func shareVideoItem(data: VideoData){
        delegate?.shareVideoItem(data: data)
    }
    
}

//
//  EntryCell.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

protocol EntryCellActionDelegate{
    func deleteEntry(entry: EntryData)
    func viewEntry(entry: EntryData)
    func viewPhotoItem(data: PhotoItemData)
    func sharePhotoItem(data: PhotoItemData)
    func viewVideoItem(data: VideoItemData)
    func shareVideoItem(data: VideoItemData)
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
        cellBody.fillView(view: contentView, insets: defaultInsets)
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.backgroundColor = transparentColor
        cellBody.removeAllSubviews()
        if let entry = entry{
            let timeLabel = UILabel()
            timeLabel.text = entry.creationDate.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.setAnchors(top: cellBody.topAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            var lastView : UIView = timeLabel
            if entry.showLocation, let loc = entry.location{
                let txt = entry.locationDescription.isEmpty ? loc.asString : entry.locationDescription
                let locationButton = TextButton(text: txt)
                locationButton.addTarget(self,action: #selector(showInMap), for: .touchDown)
                cellBody.addSubview(locationButton)
                locationButton.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                lastView = locationButton
            }
            if isEditing{
                let deleteButton = IconButton(icon: "trash")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewEntry), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            }
            var items = Array<EntryItem>()
            for item in entry.items{
                switch item.type{
                case .text:
                    let itemView = TextItemView.fromData(data: item.data as! TextItemData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                case .audio:
                    let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                case .photo, .video:
                    items.append(item)
                }
            }
            let nItems = items.count
            if nItems > 0{
                let mediaView = UIView()
                cellBody.addSubview(mediaView)
                mediaView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                lastView = mediaView
                
                let cols = Int(floor(sqrt(Double(nItems - 1)))) + 1
                let rows = nItems/cols
                let percentage = 1.0 / Double(cols)
                var itemTopAnchor = mediaView.topAnchor
                var itemLeadingAnchor = cellBody.leadingAnchor
                var itemView : UIView? = nil
                for idx in 0..<items.count{
                    let item = items[idx]
                    switch item.type{
                    case .photo:
                        itemView = PhotoItemView.fromData(data: item.data as! PhotoItemData, delegate: self)
                    case .video:
                        itemView = VideoItemView.fromData(data: item.data as! VideoItemData, delegate: self)
                    default:
                        continue
                    }
                    mediaView.addSubview(itemView!)
                    itemView!.setAnchors()
                        .top(itemTopAnchor)
                        .leading(itemLeadingAnchor)
                        .width(mediaView.widthAnchor, percentage: percentage, inset: 0)
                        .height(mediaView.widthAnchor, percentage: percentage, inset: 0)
                    if idx % cols == cols - 1{
                        itemView?.trailing(mediaView.trailingAnchor, inset: 0)
                        itemTopAnchor = itemView?.bottomAnchor ?? mediaView.topAnchor
                        itemLeadingAnchor = mediaView.leadingAnchor
                    }
                    else{
                        itemLeadingAnchor = itemView?.trailingAnchor ?? mediaView.leadingAnchor
                    }
                    if idx/cols == rows{
                        itemView?.bottom(mediaView.bottomAnchor)
                    }
                }
            }
            lastView.bottom(cellBody.bottomAnchor, inset: -defaultInset)
        }
    }
    
    @objc func showInMap(){
        if let location = entry?.location{
            let mapController = MainTabController.getMapViewController()
            mapController?.mkMapView.centerToLocation(location, regionRadius: 1000)
            MainTabController.instance.selectedViewController = mapController
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
    
    func viewPhotoItem(data: PhotoItemData){
        delegate?.viewPhotoItem(data: data)
    }
    
    func sharePhotoItem(data: PhotoItemData){
        delegate?.sharePhotoItem(data: data)
    }
    
    func viewVideoItem(data: VideoItemData){
        delegate?.viewVideoItem(data: data)
    }
    
    func shareVideoItem(data: VideoItemData){
        delegate?.shareVideoItem(data: data)
    }
    
}

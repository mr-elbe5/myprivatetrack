//
//  EntryData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

class EntryData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
        case latitude
        case longitude
        case saveLocation
        case texts
        case audios
        case images
        case videos
        case locations
    }
    
    public var id: UUID
    public var creationDate: Date
    public var coordinate: CLLocationCoordinate2D
    public var saveLocation: Bool
    public var texts: Array<TextData>
    public var audios: Array<AudioData>
    public var images: Array<ImageData>
    public var videos: Array<VideoData>
    public var locations: Array<LocationData>
    
    public var items = Array<EntryItemData>()
    
    public var isNew = false
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
        coordinate = CLLocationCoordinate2D()
        saveLocation = true
        texts = []
        audios = []
        images = []
        videos = []
        locations = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        if saveLocation{
            let latitude = try values.decode(Double.self, forKey: .latitude)
            let longitude = try values.decode(Double.self, forKey: .longitude)
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }else{
            coordinate = CLLocationCoordinate2D()
        }
        texts = try values.decode(Array<TextData>.self, forKey: .texts)
        audios = try values.decode(Array<AudioData>.self, forKey: .audios)
        images = try values.decode(Array<ImageData>.self, forKey: .images)
        videos = try values.decode(Array<VideoData>.self, forKey: .videos)
        locations = try values.decode(Array<LocationData>.self, forKey: .locations)
        setItems()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(saveLocation, forKey: .saveLocation)
        if saveLocation{
            try container.encode(coordinate.latitude, forKey: .latitude)
            try container.encode(coordinate.longitude, forKey: .longitude)
        }
        try container.encode(texts, forKey: .texts)
        try container.encode(audios, forKey: .audios)
        try container.encode(images, forKey: .images)
        try container.encode(videos, forKey: .videos)
        try container.encode(locations, forKey: .locations)
    }
    
    func setItems(){
        items.removeAll()
        for text in texts{
            items.append(text)
        }
        for audio in audios{
            items.append(audio)
        }
        for image in images{
            items.append(image)
        }
        for video in videos{
            items.append(video)
        }
        for location in locations{
            items.append(location)
        }
        sortItems()
    }
    
    func sortItems(){
        items.sort{
            $0.creationDate < $1.creationDate
        }
    }
    
    func addText(entry : TextData){
        texts.append(entry)
        items.append(entry)
        sortItems()
    }
    
    func addAudio(entry : AudioData){
        audios.append(entry)
        items.append(entry)
        sortItems()
    }
    
    func addImage(entry : ImageData){
        images.append(entry)
        items.append(entry)
        sortItems()
    }
    
    func addVideo(entry : VideoData){
        videos.append(entry)
        items.append(entry)
        sortItems()
    }
    
    func addLocation(entry : LocationData){
        locations.append(entry)
        items.append(entry)
        sortItems()
    }
    
    func removeItem(item: EntryItemData){
        item.prepareDelete()
        for i in 0..<items.count{
            if items[i].id == item.id{
                items.remove(at: i)
                break
            }
        }
        switch item.type{
        case .text:
            for i in 0..<texts.count{
                if texts[i].id == item.id{
                    texts.remove(at: i)
                    break
                }
            }
            break
        case .audio:
            for i in 0..<audios.count{
                if audios[i].id == item.id{
                    audios.remove(at: i)
                    break
                }
            }
            break
        case .image:
            for i in 0..<images.count{
                if images[i].id == item.id{
                    images.remove(at: i)
                    break
                }
            }
            break
        case .video:
            for i in 0..<videos.count{
                if videos[i].id == item.id{
                    videos.remove(at: i)
                    break
                }
            }
            break
        case .location:
            for i in 0..<locations.count{
                if locations[i].id == item.id{
                    locations.remove(at: i)
                    break
                }
            }
            break
        default: break
        }
    }
    
    func removeAllItems(){
        prepareDeleteItems()
        texts.removeAll()
        audios.removeAll()
        images.removeAll()
        videos.removeAll()
        locations.removeAll()
        items.removeAll()
    }
    
    func prepareDeleteItems(){
        for item in items{
            item.prepareDelete()
        }
    }
    
    func isComplete()-> Bool{
        for item in items{
            if !item.isComplete(){
                return false
            }
        }
        return true
    }
    
}

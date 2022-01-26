//
//  MapData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.08.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MapPhotoItemData: FileEntryItemData{
    
    enum MapEntryCodingKeys: String, CodingKey {
        case title
    }
    
    var title: String = ""
    
    private var image : UIImage? = nil
    
    override var type : EntryItemType{
        get{
            return .mapphoto
        }
    }
    
    override var fileName : String {
        get{
            return "map_\(creationDate.fileDate()).jpg"
        }
    }
    
    init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MapEntryCodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: MapEntryCodingKeys.self)
        try container.encode(title, forKey: .title)
    }
    
    func getImage() -> UIImage?{
        if let data = getFile(){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    func saveImage(uiImage: UIImage){
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            saveFile(data: data)
        }
    }
    
}

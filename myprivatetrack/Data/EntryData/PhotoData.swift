//
//  PhotoData.swift
//
//  Created by Michael Rönnau on 04.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class PhotoData : FileEntryItemData{
    
    enum PhotoEntryCodingKeys: String, CodingKey {
        case title
    }
    
    var title: String = ""
    
    private var image : UIImage? = nil
    
    override var type : EntryItemType{
        get{
            return .photo
        }
    }
    
    override var fileName : String {
        get{
            return "img_\(creationDate.fileDate()).jpg"
        }
    }
    
    init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PhotoEntryCodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: PhotoEntryCodingKeys.self)
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

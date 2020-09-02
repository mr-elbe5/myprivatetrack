//
//  VideoData.swift
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class VideoData : MediaData{
    
    enum VideoCodingKeys: String, CodingKey {
        case time
    }
    
    public var time: Double = 0.0
    
    override public var type : EntryItemType{
        get{
            return .video
        }
    }

    override var fileName : String {
        get{
            return "video\(creationDate.fileDate()).mp4"
        }
    }
    
    override init(){
        time = 0.0
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: VideoCodingKeys.self)
        time = try values.decode(Double.self, forKey: .time)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: VideoCodingKeys.self)
        try container.encode(time, forKey: .time)
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
    
}
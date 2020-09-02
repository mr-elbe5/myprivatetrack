//
//  AudioData.swift
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class AudioData : MediaData{
    
    enum AudioCodingKeys: String, CodingKey {
        case time
    }
    
    public var time: Double = 0.0
    
    override public var type : EntryItemType{
        get{
            return .audio
        }
    }

    override var fileName : String {
        get{
            return "audio_\(creationDate.fileDate()).m4a"
        }
    }
    
    override init(){
        time = 0.0
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AudioCodingKeys.self)
        time = try values.decode(Double.self, forKey: .time)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: AudioCodingKeys.self)
        try container.encode(time, forKey: .time)
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
}

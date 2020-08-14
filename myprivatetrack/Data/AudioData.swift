//
//  AudioData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class AudioData : MediaData{
    
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
    
    override func addToEntry(entry: EntryData){
        entry.addAudio(entry: self)
    }
    
    override func removeFromEntry(entry: EntryData){
        _ = deleteFiles()
        entry.removeAudio(entry: self)
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
}

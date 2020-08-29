//
//  AudioData.swift
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
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
}

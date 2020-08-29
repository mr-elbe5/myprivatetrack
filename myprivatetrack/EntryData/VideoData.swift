//
//  VideoData.swift
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class VideoData : MediaData{
    
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
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
    
}

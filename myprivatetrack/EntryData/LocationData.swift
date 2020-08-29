//
//  LocationData.swift
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class LocationData: MediaData{
    
    private var image : UIImage? = nil
    
    override public var type : EntryItemType{
        get{
            return .location
        }
    }
    
    override var fileName : String {
        get{
            return "map_\(creationDate.fileDate()).jpg"
        }
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
    
}

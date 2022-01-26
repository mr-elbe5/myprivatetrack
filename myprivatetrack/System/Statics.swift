//
//  ViewStatics.swift
//
//  Created by Michael Rönnau on 21.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

enum MapStartSize: Double{
    case small = 100.0
    case mid = 1000.0
    case large = 5000.0
}

struct Statics{
    
    static var tabColor : UIColor = .systemGray6
    
    static var backupDir : String = "backups"
    
    static var exportDir : String = "export"
    
    static var backupOfName : String = "backup_of_"
    
    static var backupName : String = "backup_"
    
    static var backgroundName : String = "background."
    
}

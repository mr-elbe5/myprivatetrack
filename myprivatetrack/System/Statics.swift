//
//  ViewStatics.swift
//
//  Created by Michael Rönnau on 21.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

enum MapStartSize: Int{
    case small = 100
    case mid = 5000
    case large = 20000
}

enum ImageMaxSide: Int{
    case small = 1024
    case mid = 20148
    case large = 4096
}

public struct Statics{
    
    public static var defaultInset : CGFloat = 10
    
    public static var defaultInsets : UIEdgeInsets = .init(top: defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset)
    
    public static var flatInsets : UIEdgeInsets = .init(top: 0, left: defaultInset, bottom: 0, right: defaultInset)
    
    public static var narrowInsets : UIEdgeInsets = .init(top: defaultInset, left: 0, bottom: defaultInset, right: 0)
    
    public static var reverseInsets : UIEdgeInsets = .init(top: -defaultInset, left: -defaultInset, bottom: -defaultInset, right: -defaultInset)
    
    public static var doubleInsets : UIEdgeInsets = .init(top: 2 * defaultInset, left: 2 * defaultInset, bottom: 2 * defaultInset, right: 2 * defaultInset)
    
    public static var backupDir : String = "backups"
    
    public static var exportDir : String = "export"
    
    public static var backupName : String = "backup_"
    
    public static var backgroundName : String = "background."
}

//
//  UIButton.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 23.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func setPrimaryDefaults(placeholder : String = ""){
        setTitleColor(UIColor.systemTeal, for: .disabled)
    }
    
    func setSecondaryDefaults(placeholder : String = ""){
        setTitleColor(UIColor.systemGray, for: .normal)
        setTitleColor(UIColor.systemGray3, for: .disabled)
    }
    
}

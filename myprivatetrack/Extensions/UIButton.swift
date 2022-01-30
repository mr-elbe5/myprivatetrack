/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

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


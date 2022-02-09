/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
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


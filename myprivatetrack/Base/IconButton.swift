/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class IconButton : UIButton{
    
    init(icon: String, tintColor: UIColor = .systemBlue, backgroundColor: UIColor? = nil){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
        self.scaleBy(1.25)
        if let bgcol = backgroundColor{
            self.backgroundColor = bgcol
            layer.cornerRadius = 5
            layer.masksToBounds = true
        }
    }
    
    init(image: String, tintColor: UIColor = .black, backgroundColor: UIColor? = nil){
        super.init(frame: .zero)
        setImage(UIImage(named: image), for: .normal)
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
        if let bgcol = backgroundColor{
            self.backgroundColor = bgcol
            layer.cornerRadius = 5
            layer.masksToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


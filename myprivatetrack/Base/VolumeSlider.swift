/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class VolumeSlider : UISlider{
    
    init(minValue: Float = 0.0, maxValue: Float = 10.0, value: Float = 2.0){
        super.init(frame: .zero)
        minimumValue = minValue
        maximumValue = maxValue
        self.value = value
        tintColor = Statics.iconColor
        minimumValueImage = UIImage(systemName: "speaker")?.withTintColor(Statics.iconColor)
        maximumValueImage = UIImage(systemName: "speaker.3")?.withTintColor(Statics.iconColor)
        self.thumbTintColor = Statics.lightIconColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

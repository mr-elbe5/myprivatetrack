/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class MediaCommentLabel : UILabel{
    
    init(text: String, tintColor: UIColor = .label){
        super.init(frame: .zero)
        self.text = text
        self.font = .italicSystemFont(ofSize: 13)
        self.numberOfLines = 0
        self.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

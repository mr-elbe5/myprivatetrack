/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoText : UIView{
    
    let label = UILabel()
    
    init(text: String){
        super.init(frame: .zero)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .label
        addSubview(label)
        label.fillView(view: self, insets: defaultInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

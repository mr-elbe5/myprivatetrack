/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoHeader : UIView{
    
    let label = UILabel()
    
    init(text: String, paddingTop: CGFloat = Insets.defaultInset){
        super.init(frame: .zero)
        label.text = text
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        label.setAnchors(leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
            .top(topAnchor, inset: paddingTop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

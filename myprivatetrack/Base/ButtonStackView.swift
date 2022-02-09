/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class ButtonStackView: UIView{
    
    var stackView = UIStackView()
    
    func setupView(){
        addSubview(stackView)
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
}

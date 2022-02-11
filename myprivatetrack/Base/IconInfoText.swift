/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class IconInfoText : UIView{
    
    let iconContainer = UIView()
    let iconView = UIImageView()
    let iconText = UILabel()
    
    init(icon: String, text: String, iconColor : UIColor = .systemBlue){
        super.init(frame: .zero)
        addSubview(iconContainer)
        iconContainer.setAnchors(top: topAnchor, leading: leadingAnchor, insets: defaultInsets)
            .width(40)
        iconView.image = UIImage(systemName: icon)
        iconView.scaleBy(1.25)
        iconView.tintColor = iconColor
        iconText.text = text
        commonInit()
    }
    
    init(image: String, text: String){
        super.init(frame: .zero)
        addSubview(iconContainer)
        iconContainer.setAnchors(top: topAnchor, leading: leadingAnchor, insets: defaultInsets)
            .width(40)
        iconView.image = UIImage(named: image)
        iconText.text = text
        commonInit()
    }
    
    private func commonInit(){
        iconText.numberOfLines = 0
        iconText.textColor = .label
        iconContainer.addSubview(iconView)
        iconView.setAnchors(top: topAnchor, leading: leadingAnchor, insets: defaultInsets)
        iconView.setAspectRatioConstraint()
        addSubview(iconText)
        iconText.setAnchors(top: topAnchor, leading: iconContainer.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

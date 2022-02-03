//
//  IconInfoText.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class IconInfoText : UIView{
    
    let iconView = UIImageView()
    let iconText = UILabel()
    
    init(icon: String, text: String, iconColor : UIColor = .systemBlue){
        super.init(frame: .zero)
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = iconColor
        iconText.text = text
        commonInit()
    }
    
    init(image: String, text: String){
        super.init(frame: .zero)
        iconView.image = UIImage(named: image)
        iconText.text = text
        commonInit()
    }
    
    private func commonInit(){
        iconText.numberOfLines = 0
        iconText.textColor = .label
        addSubview(iconView)
        iconView.setAnchors(top: topAnchor, leading: leadingAnchor, insets: defaultInsets)
            .width(25)
        iconView.setAspectRatioConstraint()
        addSubview(iconText)
        iconText.setAnchors(top: topAnchor, leading: iconView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

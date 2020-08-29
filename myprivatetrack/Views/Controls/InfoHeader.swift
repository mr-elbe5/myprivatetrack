//
//  InfoHeader.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class InfoHeader : UIView{
    
    let label = UILabel()
    
    public init(text: String, paddingTop: CGFloat = Statics.defaultInset){
        super.init(frame: .zero)
        label.text = text
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        addSubview(label)
        label.enableAnchors()
        label.setTopAnchor(topAnchor, padding: paddingTop)
        label.setLeadingAnchor(leadingAnchor,padding: defaultInset)
        label.setTrailingAnchor(trailingAnchor,padding: defaultInset)
        label.setBottomAnchor(bottomAnchor, padding: defaultInset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

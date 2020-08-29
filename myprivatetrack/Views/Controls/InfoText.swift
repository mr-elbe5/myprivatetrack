//
//  InfoText.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class InfoText : UIView{
    
    let label = UILabel()
    
    public init(text: String){
        super.init(frame: .zero)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .label
        addSubview(label)
        label.fillSuperview(padding: defaultInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  MediaTitleLabel.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 11.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MediaTitleLabel : UILabel{
    
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

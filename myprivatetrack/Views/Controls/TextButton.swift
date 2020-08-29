//
//  TextButton.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 08.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class TextButton : UIButton{
    
    public init(text: String){
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(UIColor.systemBlue, for: .normal)
        tintColor = UIColor.systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

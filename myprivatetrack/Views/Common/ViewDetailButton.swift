//
//  ViewDetailButton.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ViewDetailButton : IconButton{
    
    init(){
        super.init(icon: "magnifyingglass")
        tintColor = UIColor.systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

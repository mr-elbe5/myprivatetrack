//
//  ViewDetailButton.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class ViewDetailButton : IconButton{
    
    public init(){
        super.init(icon: "magnifyingglass")
        tintColor = UIColor.systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

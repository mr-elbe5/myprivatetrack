//
//  ViewDetailButton.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class ViewDetailButton : IconButton{
    
    public init(withBackground: Bool = false){
        super.init(icon: "magnifyingglass")
        tintColor = UIColor.systemGray
        if withBackground{
            backgroundColor = .systemBackground
            layer.cornerRadius = 5
            layer.masksToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

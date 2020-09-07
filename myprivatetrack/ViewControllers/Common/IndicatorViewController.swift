//
//  IndicatorViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 07.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class IndicatorViewController: UIViewController{
    
    var indicator = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .red
        view.addSubview(indicator)
        indicator.setCentral(view: view)
        indicator.startAnimating()
    }
    
}


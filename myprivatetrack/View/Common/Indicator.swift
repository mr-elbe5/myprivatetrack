//
//  IndicatorView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 07.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class Indicator{
    
    var indicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    class var shared: Indicator {
        struct Static {
            static let instance: Indicator = Indicator()
        }
        return Static.instance
    }

    public func show() {
            let window = UIApplication.shared.windows.first!
            indicatorView.frame = CGRect(x:0, y:0, width:80, height:80)
        indicatorView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
        indicatorView.backgroundColor = .white
            indicatorView.clipsToBounds = true
            indicatorView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y:0, width: 40, height: 40)
            activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: indicatorView.bounds.width / 2, y: indicatorView.bounds.height / 2)

            indicatorView.addSubview(activityIndicator)
            window.addSubview(indicatorView)

            activityIndicator.startAnimating()
    }

    public func hide() {
        activityIndicator.stopAnimating()
        indicatorView.removeFromSuperview()
    }

    
}

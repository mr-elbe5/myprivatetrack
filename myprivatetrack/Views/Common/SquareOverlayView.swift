//
//  SquareOverlayView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 06.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class SquareOverlayView : UIView{
    
    private var visibleView = UIView()
    private var coverView1 = UIView()
    private var coverView2 = UIView()
    
    func setupView(){
        self.backgroundColor = UIColor.clear
        visibleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        coverView1.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        coverView2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(visibleView)
        addSubview(coverView1)
        addSubview(coverView2)
    }
    
    override func layoutSubviews(){
        //landscape
        removeAllConstraints()
        if bounds.width > bounds.height{
            visibleView.enableAnchors()
            visibleView.setCenterXAnchor(centerXAnchor)
            visibleView.setCenterYAnchor(centerYAnchor)
            visibleView.setHeightAnchor(heightAnchor)
            visibleView.setSquareAnchorByHeight()
            coverView1.placeAfter(anchor: leadingAnchor, padding: .zero)
            coverView1.setTrailingAnchor(visibleView.leadingAnchor)
            coverView2.placeAfter(view: visibleView, padding: .zero)
            coverView2.setTrailingAnchor(trailingAnchor)
        }
        //portrait
        else{
            visibleView.enableAnchors()
            visibleView.setCenterXAnchor(centerXAnchor)
            visibleView.setCenterYAnchor(centerYAnchor)
            visibleView.setWidthAnchor(widthAnchor)
            visibleView.setSquareAnchorByWidth()
            coverView1.placeBelow(anchor: topAnchor, padding: .zero)
            coverView1.setBottomAnchor(visibleView.topAnchor)
            coverView2.placeBelow(view: visibleView, padding: .zero)
            coverView2.setBottomAnchor(bottomAnchor)
        }
    }
    
    
    
    
    
}

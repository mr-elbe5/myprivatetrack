//
//  TextView.swift
//  e5appviews
//
//  Created by Michael Rönnau on 28.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class TextView : UIView, UITextFieldDelegate{
    
    private var label = UILabel()
    private var textField = UITextField()
    
    public var text: String?{
        get{
            return textField.text
        }
    }
    
    public func setupView(labelText: String, text: String = "", secure : Bool = false){
        label.text = labelText
        addSubview(label)
        textField.setDefaults()
        textField.isSecureTextEntry = secure
        textField.text = text
        addSubview(textField)
        label.placeAfter(anchor: leadingAnchor)
        textField.placeBefore(anchor: trailingAnchor)
        textField.setLeadingAnchor(centerXAnchor)
    }
    
}

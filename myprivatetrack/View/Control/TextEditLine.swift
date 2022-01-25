//
//  TextEditLine.swift
//
//  Created by Michael Rönnau on 28.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TextEditLine : UIView, UITextFieldDelegate{
    
    private var label = UILabel()
    private var textField = UITextField()
    
    var text: String?{
        get{
            return textField.text
        }
    }
    
    func setupView(labelText: String, text: String = "", secure : Bool = false){
        label.text = labelText
        addSubview(label)
        textField.setDefaults()
        textField.isSecureTextEntry = secure
        textField.text = text
        addSubview(textField)
        label.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        textField.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        textField.leading(centerXAnchor)
    }
    
}

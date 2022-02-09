/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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

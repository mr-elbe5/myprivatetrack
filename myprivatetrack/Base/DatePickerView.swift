/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol DatePickerDelegate{
    func dateValueDidChange(sender: DatePickerView,date: Date?)
}

class DatePickerView : UIView{
    
    private var label = UILabel()
    private var datePicker = UIDatePicker()
    
    var delegate : DatePickerDelegate? = nil
    
    func setupView(labelText: String, date : Date?, minimumDate : Date? = nil){
        label.text = labelText
        addSubview(label)
        datePicker.timeZone = .none
        if let date = date{
            datePicker.date = date
        } else{
            datePicker.date = Date()
        }
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        addSubview(datePicker)
        label.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        datePicker.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    @objc func valueDidChange(sender:UIDatePicker){
        delegate?.dateValueDidChange(sender: self,date: sender.date)
    }
    
}


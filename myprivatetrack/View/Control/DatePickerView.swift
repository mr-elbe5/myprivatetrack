//
//  DatePickerView.swift
//
//  Created by Michael Rönnau on 17.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

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
        label.placeAfter(anchor: leadingAnchor)
        datePicker.placeBefore(anchor: trailingAnchor)
    }
    
    @objc func valueDidChange(sender:UIDatePicker){
        delegate?.dateValueDidChange(sender: self,date: sender.date)
    }
    
}


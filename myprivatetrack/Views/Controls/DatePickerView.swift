//
//  DatePickerView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 17.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public protocol DatePickerDelegate{
    func dateValueDidChange(sender: DatePickerView,date: Date?)
}

public class DatePickerView : UIView{
    
    private var label = UILabel()
    private var datePicker = UIDatePicker()
    
    public var delegate : DatePickerDelegate? = nil
    
    public func setupView(labelText: String, date : Date?, minimumDate : Date? = nil){
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
    
    @objc public func valueDidChange(sender:UIDatePicker){
        delegate?.dateValueDidChange(sender: self,date: sender.date)
    }
    
}


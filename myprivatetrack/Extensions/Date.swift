//
//  Date.swift
//  E5Data
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

extension Date{
    
    public func startOfDay() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal.startOfDay(for: self)
    }
    
    public func startOfMonth() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let components = cal .dateComponents([.month, .year], from: self)
        return cal.date(from: components)!
    }
    
    public func dateString() -> String{
        return DateFormats.dateOnlyFormatter.string(from: self)
    }
    
    public func dateTimeString() -> String{
        return DateFormats.dateTimeFormatter.string(from: self)
    }
    
    public func fileDate() -> String{
        return DateFormats.fileDateFormatter.string(from: self)
    }
    
    public func timeString() -> String{
        return DateFormats.timeOnlyFormatter.string(from: self)
    }
    
}

extension Date {
 
    public var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    public init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

class DateFormats{
    
    public static var dateOnlyFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter
        }
    }
    
    public static var timeOnlyFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return dateFormatter
        }
    }
    
    public static var dateTimeFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter
        }
    }
    
    public static var fileDateFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .none
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            return dateFormatter
        }
    }
    
}


//
//  TimeSpanData.swift
//
//  Created by Michael Rönnau on 22.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class TimeSpanData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case days
    }
    
    public var days: Array<DayData>
    private var dayMap = Dictionary<Date, DayData>()
    
    init(){
        days = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        days = try values.decode(Array<DayData>.self, forKey: .days)
        dayMap.removeAll()
        for day in days{
            dayMap[day.date] = day
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
    }
    
    func assertDay(date : Date) -> DayData{
        let dayDate = date.startOfDay()
        var dayData = dayMap[dayDate]
        if dayData == nil {
            dayData = DayData()
            dayData!.date = dayDate
            days.append(dayData!)
            dayMap[dayDate] = dayData!
        }
        return dayData!
    }
    
}

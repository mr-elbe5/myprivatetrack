//
//  DataContainer.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class DataContainer: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case days
    }
    
    public var days: Array<DayData>
    private var dayMap = Dictionary<Date, DayData>()
    
    var firstDayDate : Date?{
        get{
            if days.isEmpty{
                return nil
            }
            return days[0].date
        }
    }
    
    var lastDayDate : Date?{
        get{
            if days.isEmpty{
                return nil
            }
            return days[days.count-1].date
        }
    }
    
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
    
    func save(){
        GlobalData.shared.saveData()
    }
    
    func deleteEntry(entry: EntryData){
        var found = false
        for dayIdx in 0..<days.count{
            let day = days[dayIdx]
            for entryIdx in 0..<day.entries.count{
                let e = day.entries[entryIdx]
                if e.id == entry.id{
                    entry.prepareDeleteItems()
                    day.entries.remove(at: entryIdx)
                    found = true
                    break
                }
            }
            if found{
                if day.entries.count == 0{
                    days.remove(at: dayIdx)
                    dayMap.removeValue(forKey: day.date)
                }
                break
            }
        }
        save()
    }
    
}

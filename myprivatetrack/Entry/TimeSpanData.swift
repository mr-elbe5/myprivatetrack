/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class TimeSpanData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case days
    }
    
    var days: Array<DayData>
    private var dayMap = Dictionary<Date, DayData>()
    
    init(){
        days = Array<DayData>()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        days = try values.decodeIfPresent(Array<DayData>.self, forKey: .days) ?? Array<DayData>()
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

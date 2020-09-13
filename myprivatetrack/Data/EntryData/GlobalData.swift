//
//  DataContainer.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class GlobalData: Identifiable, Codable{
    
    static var temporaryFileName = "globalData.json"
    
    static var shared = GlobalData()
    
    static func load(){
        shared = DataController.shared.load(forKey: .data) ?? GlobalData()
    }
    
    static func readFromTemporaryFile() -> GlobalData{
        let url = FileController.getURL(dirURL: FileController.temporaryURL,fileName: GlobalData.temporaryFileName)
        let storeString = FileController.readTextFile(url: url)
        print(storeString ?? "nil")
        return GlobalData.fromJSON(encoded: storeString!) ?? GlobalData()
    }
    
    enum CodingKeys: String, CodingKey {
        case days
    }
    
    var days: Array<DayData>
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
    
    func addDay(day: DayData){
        //print("adding with date \(day.date.dateString())")
        days.append(day)
        dayMap[day.date] = day
    }
    
    func save(){
        DataController.shared.save(forKey: .data, value: self)
    }
    
    func getCopy(fromDate: Date, toDate: Date) -> GlobalData{
        let newData = GlobalData()
        for day in days{
            if day.date < fromDate || day.date > toDate{
                continue
            }
            newData.days.append(day)
        }
        return newData
    }
    
    func getActiveFileNames() -> Array<String>{
        var fileNames = Array<String>()
        for day in days{
            day.addActiveFileNames(to: &fileNames)
        }
        return fileNames
    }
    
    func saveAsTemporaryFile() -> URL? {
        let storeString = self.toJSON()
        let url = FileController.getURL(dirURL: FileController.temporaryURL,fileName: GlobalData.temporaryFileName)
        return FileController.saveFile(text: storeString, url: url) ? url : nil
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
    
    func reset(){
        days.removeAll()
        dayMap.removeAll()
        save()
    }
    
    func sortDays(){
        days.sort {
            $0.date < $1.date
        }
    }
    
}

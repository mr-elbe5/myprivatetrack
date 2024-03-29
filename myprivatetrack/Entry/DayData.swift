/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class DayData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case date
        case entries
    }
    
    var date: Date
    var entries: Array<EntryData>
    
    var lastIdx : Int?{
        entries.isEmpty ? nil : entries.count - 1
    }
    
    init(){
        date = Date()
        entries = Array<EntryData>()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        entries = try values.decodeIfPresent(Array<EntryData>.self, forKey: .entries) ?? Array<EntryData>()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(entries, forKey: .entries)
    }
    
    func addEntry(entry: EntryData){
        entries.append(entry)
    }
    
    func sortEntries(){
        entries.sort {
            $0.creationDate < $1.creationDate
        }
    }
    
    func getEntryIdx(entry: EntryData) -> Int?{
        for idx in 0..<entries.count{
            if entry.id == entries[idx].id{
                return idx
            }
        }
        return nil
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        for entry in entries{
            entry.addActiveFileNames(to: &fileNames)
        }
    }

}

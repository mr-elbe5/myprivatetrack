//
//  DayData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class DayData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case date
        case entries
    }
    
    public var date: Date
    public var entries: Array<EntryData>
    
    init(){
        date = Date()
        entries = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Date.self, forKey: .date)
        entries = try values.decode(Array<EntryData>.self, forKey: .entries)
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
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        for entry in entries{
            entry.addActiveFileNames(to: &fileNames)
        }
    }

}

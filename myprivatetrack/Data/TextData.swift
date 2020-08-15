//
//  TextData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class TextData: EntryItemData{
    
    enum TextCodingKeys: String, CodingKey {
        case text
        case multiline
    }
    
    override public var type : EntryItemType{
        get{
            return .text
        }
    }
    
    public var text: String
    public var isMultiline: Bool
    
    override init(){
        text = ""
        isMultiline = false
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TextCodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        isMultiline = try values.decode(Bool.self, forKey: .multiline)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: TextCodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(isMultiline, forKey: .multiline)
    }
    
    override func isComplete() -> Bool{
        return text.count > 0
    }
    
}

//
//  Codable.swift
//  test.ios
//
//  Created by Michael Rönnau on 01.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

extension Decodable{
    static func deserialize<T: Decodable>(encoded : String) -> T?{
        if let data = Data(base64Encoded: encoded){
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(T.self, from : data)
        }
        return nil
    }
    
    static func fromJSON<T: Decodable>(encoded : String) -> T?{
        if let data =  encoded.data(using: .utf8){
            return try? JSONDecoder().decode(T.self, from : data)
        }
        return nil
    }
    
}

extension Encodable{
    func serialize() -> String{
        if let json = try? JSONEncoder().encode(self).base64EncodedString(){
            return json
        }
        return ""
    }
    
    func toJSON() -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(self){
            if let s = String(data:data, encoding: .utf8){
                return s
            }
        }
        return ""
    }
    
}

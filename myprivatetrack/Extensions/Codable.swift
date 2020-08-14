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
        return try? JSONDecoder().decode(T.self, from : Data(base64Encoded: encoded)!)
    }
    
}

extension Encodable{
    func serialize() -> String{
        if let json = try? JSONEncoder().encode(self).base64EncodedString(){
            return json
        }
        return ""
    }
    
}

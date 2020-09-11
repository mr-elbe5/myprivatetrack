//
//  DataStore.swift
//
//  Created by Michael Rönnau on 21.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

public class DataController{
    
    public enum StoreKey: String, CaseIterable {
        case settings
        case data
        case user
    }
    
    public static var shared = DataController()
    
    let store: UserDefaults
    
    private init() {
        self.store = UserDefaults.standard
    }
    
    public func save(forKey key: StoreKey, value: Codable) {
        let storeString = value.toJSON()
        store.set(storeString, forKey: key.rawValue)
    }
    
    public func load<T : Codable>(forKey key: StoreKey) -> T? {
        if let storedString = store.value(forKey: key.rawValue) as? String {
            return T.fromJSON(encoded: storedString)
        }
        print("no saved data available for \(key.rawValue)")
        return nil
    }
    
}

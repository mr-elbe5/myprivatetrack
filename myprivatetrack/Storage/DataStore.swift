//
//  Store.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 02.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class DataStore{
    
    enum StoreKey: String, CaseIterable {
        case settings
        case data
    }
    
    public static var shared = DataStore()
    
    let store: UserDefaults
    
    var settings : Settings!
    var data : DataContainer!
    
    private init() {
        self.store = UserDefaults.standard
    }
    
    private func save(forKey key: StoreKey, value: Codable) {
        let storeString = value.serialize()
        store.set(storeString, forKey: key.rawValue)
    }
    
    private func load<T : Codable>(forKey key: StoreKey) -> T? {
        if let storedString = store.value(forKey: key.rawValue) as? String {
            return T.deserialize(encoded: storedString)
        }
        return nil
    }
    
    //MARK : publics
    
    public func loadSettings(){
        settings = load(forKey: .settings) ?? Settings()
    }
    
    public func loadData(){
        data = load(forKey: .data) ?? DataContainer()
    }
    
    public func saveSettings(){
        save(forKey: .settings, value: settings)
    }
    
    public func saveData(){
        save(forKey: .data, value: data)
    }
    
}

/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class DataController{
    
    enum StoreKey: String, CaseIterable {
        case settings
        case data
    }
    
    static var shared = DataController()
    
    let store: UserDefaults
    
    private init() {
        self.store = UserDefaults.standard
    }
    
    func save(forKey key: StoreKey, value: Codable) {
        let storeString = value.toJSON()
        store.set(storeString, forKey: key.rawValue)
    }
    
    func load<T : Codable>(forKey key: StoreKey) -> T? {
        if let storedString = store.value(forKey: key.rawValue) as? String {
            return T.fromJSON(encoded: storedString)
        }
        print("no saved data available for \(key.rawValue)")
        return nil
    }
    
}

/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension Array{
    
    mutating func remove<T : Equatable>(obj : T){
        for i in 0..<count{
            if obj == self[i] as? T{
                remove(at: i)
                return
            }
        }
    }
    
    func getTypedArray<T>(type: T.Type) -> Array<T>{
        var arr = Array<T>()
        for data in self{
            if let obj = data as? T {
                arr.append(obj)
            }
        }
        return arr
    }
    
}


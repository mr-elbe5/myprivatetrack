/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension NSLock {
    func withCriticalScope<T>(block:() -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

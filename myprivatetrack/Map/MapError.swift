/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

enum MapError: Swift.Error {
    case snapshot
    case unexpected
}

extension MapError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .snapshot: return "snapshotError".localize()
        case .unexpected: return "unexpectedError".localize()
        }
    }
}

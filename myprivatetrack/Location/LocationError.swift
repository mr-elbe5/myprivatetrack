/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

enum LocationError: Swift.Error {
    case unauthorized
    case timeout
    case unexpected
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unauthorized: return "unauthorizedError".localize()
        case .timeout: return "timeoutError".localize()
        case .unexpected: return "unexpectedError".localize()
        }
    }
}

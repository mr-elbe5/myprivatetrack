/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

enum AuthorizationError: Swift.Error {
    case rejected
    case unexpected
}

extension AuthorizationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .rejected: return "rejectedError".localize()
        case .unexpected: return "unexpectedError".localize()
        }
    }
}

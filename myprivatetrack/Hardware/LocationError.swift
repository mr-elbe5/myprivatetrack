//
//  LocationError.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 31.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

public enum LocationError: Swift.Error {
    case unauthorized
    case timeout
    case unexpected
}

extension LocationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized: return "unauthorizedError".localize()
        case .timeout: return "timeoutError".localize()
        case .unexpected: return "unexpectedError".localize()
        }
    }
}

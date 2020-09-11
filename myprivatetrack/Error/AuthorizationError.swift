//
//  AuthorizationError.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

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

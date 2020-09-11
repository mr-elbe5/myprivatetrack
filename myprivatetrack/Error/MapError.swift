//
//  MapError.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

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

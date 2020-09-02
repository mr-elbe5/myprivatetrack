//
//  FileError.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 31.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

enum FileError: Swift.Error {
    case read
    case save
    case unauthorized
    case unexpected
}

extension FileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .read: return "readError".localize()
        case .save: return "saveError".localize()
        case .unauthorized: return "unauthorizedError".localize()
        case .unexpected: return "unexpectedError".localize()
        }
    }
}


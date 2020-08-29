//
//  URL.swift
//  e5appdata
//
//  Created by Michael Rönnau on 26.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

extension URL {
    
    public var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }

}

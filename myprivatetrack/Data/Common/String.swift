//
//  String.swift
//
//  Created by Michael Rönnau on 18.05.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func localize() -> String{
        return NSLocalizedString(self,comment: "")
    }
    
    public func localize(i: Int) -> String{
        return String(format: NSLocalizedString(self,comment: ""), String(i))
    }
    
    public func localize(s: String) -> String{
        return String(format: NSLocalizedString(self,comment: ""), s)
    }
    
    public func trim() -> String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    

}

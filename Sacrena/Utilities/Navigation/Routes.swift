//
//  Routes.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation
import StreamChat

enum Routes: Hashable{
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: Routes, rhs: Routes) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    case chat(ChatClient)
}


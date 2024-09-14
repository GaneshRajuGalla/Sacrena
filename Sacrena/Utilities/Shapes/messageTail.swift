//
//  messageTail.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI

struct messageTail: Shape {
    var from: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, from ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}

//
//  View+Extension.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI

extension View {
    func navigation(path: Binding<[Routes]>) -> some View {
        self.modifier(NavigationModifier(route: path))
    }
    
    func textStyle(color: Color = .primary,
                   font: Font = .body,
                   weight: Font.Weight = .regular,
                   alignment: TextAlignment = .center) -> some View {
        self.modifier(TextStyleModifier(color: color, font: font, weight: weight, alignment: alignment))
    }
    
    func flipped() -> some View {
        self.rotationEffect(.radians(Double.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
    

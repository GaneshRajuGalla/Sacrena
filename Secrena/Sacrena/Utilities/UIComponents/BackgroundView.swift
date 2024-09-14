//
//  BackgroundView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    
    var color: Color = Color.white
    var borderColor: Color = Color.gray
    var cornerRadius: CGFloat = 20
    var lineWidth: CGFloat = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(color)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

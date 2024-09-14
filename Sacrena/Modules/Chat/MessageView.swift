//
//  MessageView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI

enum MessageType {
    case from
    case to
}

struct MessageView: View {
    
    // MARK: - Properties
    let type: MessageType
    let message: String
    
    private var from: Bool {
        type == .from
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 2) {
            contentView
        }
        .background(from ? .white : .accentColor)
        .clipShape(messageTail(from: from))
    }
}

extension MessageView {
    
    @ViewBuilder
    private var contentView: some View {
        HStack(alignment: .bottom, spacing: 5){
            if from {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 30)
            }
            Text(message)
                .textStyle(color: .black, font: .caption, alignment: .leading)
        }
    }
}

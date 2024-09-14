//
//  SacrenaChannelHeaderModifier.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct SacrenaChannelHeaderModifier: ChatChannelHeaderViewModifier {
    
    let channel: ChatChannel
    
    func body(content: Content) -> some View {
        content.toolbar {
            SacrenaChannelHeader(channel: channel)
        }
    }
}

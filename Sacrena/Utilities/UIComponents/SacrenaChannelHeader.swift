//
//  SacrenaChannelHeader.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct SacrenaChannelHeader: ToolbarContent {
    
    // MARK: - Properties
    @ObservedObject private var channelHeaderLoader = InjectedValues[\.utils].channelHeaderLoader
    @Injected(\.chatClient) var chatClient
    @Injected(\.utils) var utils
    @Injected(\.fonts) var fonts
    @Injected(\.colors) var colors

    var channel: ChatChannel
    
    private var currentUserId: String {
        chatClient.currentUserId ?? ""
    }
    
    private var channelNamer: ChatChannelNamer {
        utils.channelNamer
    }

    // MARK: - Body
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                ChannelAvatarView(
                    avatar: channelHeaderLoader.image(for: channel),
                    showOnlineIndicator: false,
                    size: CGSize(width: 36, height: 36)
                )
                Text(channelNamer(channel, currentUserId) ?? "")
                    .font(fonts.bodyBold)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                print("tapped on More")
            }, label: {
                Image(systemName: "ellipsis")
            })
        }
    }
}

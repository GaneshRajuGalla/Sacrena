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
    let channel: ChatChannel
    let chatClient: ChatClient
    @Injected(\.utils) var utils
    let completion: DefaultHandler?
    
    private var currentUserId: String {
        chatClient.currentUserId ?? ""
    }
    
    private var channelNamer: ChatChannelNamer {
        utils.channelNamer
    }
    
    // MARK: - Body
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: 10){
                Button(action: {
                    completion?()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.white)
                })
                
                HStack {
                    if let imageURL = imageURL(for: channel) {
                        StreamLazyImage(url: imageURL, size: CGSize(width: 36, height: 36))
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 36, height: 36)
                    }
                    Text(channelNamer(channel, currentUserId) ?? "")
                        .textStyle(color: .white, font: .headline, weight: .bold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.trailing)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                print("tapped on More")
            }, label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white)
            })
        }
    }
    
    func imageURL(for channel: ChatChannel) -> URL? {
        channel.lastActiveMembers.first(where: { member in
            member.id != chatClient.currentUserId
        })?.imageURL
    }
}

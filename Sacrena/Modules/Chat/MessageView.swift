//
//  MessageView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct MessageView: View {
    
    // MARK: - Properties
    let channel: ChatChannel
    let message: ChatMessage
    @Injected(\.chatClient) var chatClient
    
    private var isSentByCurrentUser: Bool {
        return message.isSentByCurrentUser
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 5){
            if !isSentByCurrentUser {
                if let imageURL = imageURL(for: channel) {
                    StreamLazyImage(url: imageURL, size: CGSize(width: 45, height: 45))
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 45)
                }
            }
            VStack(alignment: .trailing, spacing: 0) {
                contentView
                Text(message.updatedAt.formattedString(using: .timeOnly))
                    .font(.system(size: 8))
                    .foregroundStyle(.black.opacity(0.5))
            }
            .padding(.top, 5)
            .padding(.horizontal, 10)
            .padding(.bottom, 15)
            .background(!isSentByCurrentUser ? .white : Color("AccentColor"))
            .clipShape(messageTail(from: isSentByCurrentUser))
        }
    }
}

extension MessageView {
    
    @ViewBuilder
    private var contentView: some View {
        Text(message.text)
            .textStyle(color: .black, font: .caption, alignment: .leading)
    }
    
    func imageURL(for channel: ChatChannel) -> URL? {
        channel.lastActiveMembers.first(where: { member in
            member.id != chatClient.currentUserId
        })?.imageURL
    }
}

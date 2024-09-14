//
//  ChatListView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//
import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct ChatListView: View {
    
    // MARK: - Properties
    @Injected(\.chatClient) var chatClient
    @EnvironmentObject var manager: NavigationManager
    @StateObject var viewModel = ChatListViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            contentView
        }
        .navigationTitle("Connections")
        .navigationBarTitleDisplayMode(.large)
        .navigation(path: $manager.chatRoutes)
    }
}

extension ChatListView {
    
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.channels) { channel in
                    chatListItem(channel)
                        .onTapGesture {
                            manager.push(route: .chat(chatClient))
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func chatListItem(_ channel: ChatChannel) -> some View {
        VStack(spacing: 2){
            HStack {
                if let imageURL = viewModel.imageURL(for: channel) {
                    StreamLazyImage(url: imageURL)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 30)
                }
                VStack(alignment: .leading) {
                    Text(DefaultChatChannelNamer()(channel, chatClient.currentUserId) ?? "")
                        .lineLimit(1)
                        .bold()
                    Text("\(channel.previewMessage?.text ?? "No messages")")
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.horizontal)
            Divider()
        }
        .onAppear {
            if let index = viewModel.channels.firstIndex(where: { chatChannel in
                chatChannel.id == channel.id
            }) {
                viewModel.checkForChannels(index: index)
            }
        }
    }
}

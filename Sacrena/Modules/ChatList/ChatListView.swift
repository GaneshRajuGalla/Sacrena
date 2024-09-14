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
            Group {
                if !viewModel.channels.isEmpty {
                    contentView
                } else {
                    contentUnavailableView
                }
            }
        }
        .navigationTitle("Connections")
        .navigationBarTitleDisplayMode(.automatic)
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
                            manager.push(route: .chat(chatClient, channel))
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func chatListItem(_ channel: ChatChannel) -> some View {
        VStack {
            HStack {
                if let imageURL = viewModel.imageURL(for: channel) {
                    StreamLazyImage(url: imageURL, size: CGSize(width: 60, height: 60))
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 60)
                }
                VStack(alignment: .leading) {
                    Text(DefaultChatChannelNamer()(channel, chatClient.currentUserId) ?? "")
                        .textStyle(color: .white, font: .headline, weight: .bold)
                        .lineLimit(1)
                    Text("\(channel.previewMessage?.text ?? "No messages")")
                        .textStyle(color: (channel.unreadCount.messages > 0) ? Color.white.opacity(0.5) : Color.white.opacity(0.4), font: .subheadline, alignment: .leading)
                        .lineLimit(2)
                }
                Spacer()
            }
            .padding(.vertical, 7)
            Divider()
        }
        .padding(.horizontal)
        .onAppear {
            if let index = viewModel.channels.firstIndex(where: { chatChannel in
                chatChannel.id == channel.id
            }) {
                viewModel.checkForChannels(index: index)
            }
        }
    }
    
    @ViewBuilder
    private var contentUnavailableView: some View {
        ContentUnavailableView(label: {
            Label(
                title: {
                    Text("This is the begining of your chat.")
                        .textStyle(color: .gray, font: .subheadline)
                },
                icon: {
                    Image(systemName: "")
                }
            )
        })
    }
}

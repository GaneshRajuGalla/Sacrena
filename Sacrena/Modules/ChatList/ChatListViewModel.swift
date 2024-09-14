//
//  ChatListViewModel.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

class ChatListViewModel: ObservableObject, ChatChannelListControllerDelegate {
    
    @Injected(\.chatClient) var chatClient
    
    @Published public var channels = LazyCachedMapCollection<ChatChannel>() {
        didSet {
            print("channels.count", channels.count)
        }
    }
    
    public private(set) var loadingNextChannels: Bool = false
    
    private var controller: ChatChannelListController?
    private var timer: Timer?
    
    init() {
        setupChannelListController()
    }
    
    public func controller(
        _ controller: ChatChannelListController,
        didChangeChannels changes: [ListChange<ChatChannel>]
    ) {
        channels = controller.channels
    }
    
    public func checkForChannels(index: Int) {
        if index < (controller?.channels.count ?? 0) - 15 {
            return
        }

        if !loadingNextChannels {
            loadingNextChannels = true
            controller?.loadNextChannels(limit: 30) { [weak self] _ in
                guard let self = self else { return }
                self.loadingNextChannels = false
            }
        }
    }
    
    func imageURL(for channel: ChatChannel) -> URL? {
        channel.lastActiveMembers.first(where: { member in
            member.id != chatClient.currentUserId
        })?.imageURL
    }
    
    //MARK: - private
    
    private func updateChannels() {
        channels = controller?.channels ?? LazyCachedMapCollection<ChatChannel>()
    }
    
    private func setupChannelListController() {
        guard let currentUserId = chatClient.currentUserId else {
            observeClientIdChange()
            return
        }
        controller = chatClient.channelListController(
            query: .init(filter: .containMembers(userIds: [currentUserId]))
        )
        
        controller?.delegate = self

        updateChannels()

        controller?.synchronize { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                print("handle error here")
            } else {
                self.updateChannels()
            }
        }
    }
    
    private func observeClientIdChange() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if self.chatClient.currentUserId != nil {
                self.timer?.invalidate()
                self.timer = nil
                self.setupChannelListController()
            }
        })
    }
}

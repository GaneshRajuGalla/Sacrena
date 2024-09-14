//
//  ChatViewModel.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//
import Combine
import StreamChat

class ChatViewModel: ObservableObject, ChatChannelControllerDelegate {
    
    @Published var messages = LazyCachedMapCollection<ChatMessage>()
    @Published var text = ""
    
    private let channelController: ChatChannelController
    private var loadingPreviousMessages = false
    private var cancellables = Set<AnyCancellable>()
    
    init(chatClient: ChatClient) {
        channelController = chatClient.channelController(
            for: try! ChannelId(cid: "messaging:5A9427AD-E")
        )
        channelController.delegate = self
        channelController.synchronize { [weak self] error in
            guard let self else { return }
            self.messages = self.channelController.messages
        }
        channelController.messagesChangesPublisher.sink { [weak self] changes in
            guard let self else { return }
            self.messages = self.channelController.messages
        }
        .store(in: &cancellables)
    }
    
    func sendMessage() {
        channelController.createNewMessage(text: text)
        text = ""
    }
    
    func handleMessageAppear(index: Int) {
        if index >= messages.count {
            return
        }
        
        checkForPreviousMessages(index: index)
    }
    
    //MARK: - private
    
    private func checkForPreviousMessages(index: Int) {
        if index < messages.count - 25 {
            return
        }

        if !loadingPreviousMessages {
            loadingPreviousMessages = true
            channelController.loadPreviousMessages(
                before: nil,
                limit: 50,
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.loadingPreviousMessages = false
                }
            )
        }
    }
}

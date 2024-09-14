//
//  SacrenaApp.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 12/09/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

@main
struct SacrenaApp: App {
    
    // MARK: - Properties
    @State var streamChat: StreamChat?
    @StateObject var manager:NavigationManager = .init()
    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init(apiKeyString))
        config.isLocalStorageEnabled = true
        let client = ChatClient(config: config)
        return client
    }()
    
    init() {
        streamChat = StreamChat(chatClient: chatClient)
        connectUser(withCredentials: UserCredentials.credential)
    }
    
    var body: some Scene {
        WindowGroup {
            ChatView(chatClient: chatClient)
                .preferredColorScheme(.dark)
                .environmentObject(manager)
        }
    }
}

// MARK: - Helper Methods
extension SacrenaApp  {
    private func connectUser(withCredentials credentials: UserCredentials) {
        chatClient.logout {}

        let token = try! Token(rawValue: credentials.token)
        LogConfig.level = .debug

        streamChat = StreamChat(chatClient: chatClient)

        chatClient.connectUser(
                userInfo: .init(id: credentials.id, name: credentials.name, imageURL: credentials.avatarURL),
                token: token
        ) { error in
            if let error = error {
                log.error("connecting the user failed \(error)")
                return
            }
        }
    }
}

//
//  ChatView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import StreamChat
import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    @State private var openCamera:Bool = false
    @State private var isPermissionDenied = false
    @EnvironmentObject var manager: NavigationManager
    @State var modelId: String?
    @State var proxy: ScrollViewProxy?
    @FocusState var isTextFieldFocus: Bool
    
    init(chatClient: ChatClient, channel: ChatChannel) {
        let viewModel = ChatViewModel(chatClient: chatClient, channel: channel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                contentView
                composerView
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            SacrenaChannelHeader(channel: viewModel.channel, chatClient: viewModel.chatClient, completion: {
                manager.popLast()
            })
        }
        .fullScreenCover(isPresented: $openCamera) {
            ImagePickerView { result in
                switch result {
                case .success(let mediaItem):
                    switch mediaItem {
                    case .image(let image):
                        break
                    case .video(let url):
                        break
                    }
                case .failure:
                    break
                }
            }
            .ignoresSafeArea()
        }
    }
}

extension ChatView {
    
    @ViewBuilder
    private var contentView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        let isSentByCurrentUser = message.isSentByCurrentUser
                        if !message.text.isEmpty {
                            renderMessageView(isSentByCurrentUser: isSentByCurrentUser) {
                                MessageView(channel: viewModel.channel, message: message)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: isSentByCurrentUser ? .trailing : .leading)
                                    .flipped()
                                    .background(Color.clear)
                            }
                            .onAppear {
                                let index = viewModel.messages.firstIndex { msg in
                                    msg.id == message.id
                                }
                                guard let index else { return }
                                viewModel.handleMessageAppear(index: index)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $modelId)
            .flipped()
            .overlay(alignment: .top){
                if viewModel.loadingPreviousMessages {
                    ProgressView()
                }
            }
            .onChange(of: isTextFieldFocus) { _ , _ in
                if isTextFieldFocus {
                    scrollToBottom()
                }
            }
            .onAppear {
                self.proxy = proxy
                scrollToBottom()
            }
        }
    }
    
    @ViewBuilder
    private var composerView: some View {
        VStack(spacing: 20) {
            Divider()
            HStack  {
                Button(action: {
                    PermissionsManager.requestPermission(type: .camera) { status in
                        if status == .authorized {
                            openCamera = true
                        } else {
                            isPermissionDenied = true
                        }
                    }
                }, label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                        .foregroundStyle(.white)
                })
                TextField("Message", text: $viewModel.text)
                    .padding(10)
                    .tint(Color.gray)
                    .foregroundColor(Color.primary)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFieldFocus)
                    .background(content: {
                        BackgroundView(color: .clear)
                    })
                Spacer()
                Button(action: {
                    viewModel.sendMessage()
                    viewModel.sentSuccessHandler = {
                        scrollToBottom()
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                        .foregroundStyle(.gray)
                })
                .disabled(viewModel.text.isEmpty)
            }
        }
        .padding(.horizontal)
    }
}

extension ChatView {
    
    private func scrollToBottom()  {
        guard let message = viewModel.messages.first else { return }
        guard let proxy = proxy else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            withAnimation {
                proxy.scrollTo(message.id, anchor: .bottom)
            }
        })
    }
    
    private func renderMessageView<Content: View>(isSentByCurrentUser: Bool,
                                                  @ViewBuilder content: () -> Content) -> some View {
        if isSentByCurrentUser {
            return AnyView(HStack {
                Spacer()
                content()
            })
        } else {
            return AnyView(content())
        }
    }
}

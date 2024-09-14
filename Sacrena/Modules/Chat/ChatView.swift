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
    
    init(chatClient: ChatClient) {
        let viewModel = ChatViewModel(chatClient: chatClient)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            contentView
            VStack {
                Spacer()
                composerView
            }
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
        ScrollView {
            LazyVStack {
                ForEach(viewModel.messages) { message in
                    if !message.text.isEmpty {
                        HStack {
                            Text(message.text)
                                .font(.footnote)
                                .bold()
                            Spacer()
                        }
                        .padding(.all, 4)
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
            .padding()
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
                    .background(content: {
                        BackgroundView(color: .clear)
                    })
                Spacer()
                Button(action: {
                    viewModel.sendMessage()
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

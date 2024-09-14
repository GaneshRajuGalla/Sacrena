//
//  NavigationModifier.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation
import SwiftUI
import StreamChat

struct NavigationModifier: ViewModifier {
    
    // MARK: - Properties
    @Binding var route: [Routes]
    
    @ViewBuilder
    fileprivate func coordinator(route: Routes) -> some View{
        switch route {
        case .chat(let chatClient, let channel):
            ChatView(chatClient: chatClient, channel: channel)
        }
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        NavigationStack(path: $route) {
            content
                .navigationDestination(for: Routes.self) { route in
                    coordinator(route: route)
                }
        }
    }
}

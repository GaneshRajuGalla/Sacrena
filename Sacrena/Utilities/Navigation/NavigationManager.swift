//
//  NavigationManager.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import SwiftUI

class NavigationManager: ObservableObject{
    
    // MARK: - Properties
    @Published var chatRoutes:[Routes] = []
    
    
    func popLast() {
        if !chatRoutes.isEmpty {
            chatRoutes.removeLast()
        }
    }
    
    func push(route:Routes){
        chatRoutes.append(route)
    }
    
    func popToRoot(){
        chatRoutes.removeAll()
    }
}




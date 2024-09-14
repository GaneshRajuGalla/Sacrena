//
//  Constants.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation

typealias DefaultHandler = (() -> ())

public let apiKeyString = "dpvhtzzns77a"
public let userId: String = "sacrena_alice"

public struct UserCredentials {
    let id: String
    let name: String
    let avatarURL: URL
    let token: String
    let birthLand: String
}

extension UserCredentials {
    
    static func builtInUsersByID(id: String) -> UserCredentials? {
        credential
    }
    
    static let credential: UserCredentials = UserCredentials(id: userId,
                                                             name: "Ganesh Raju Galla",
                                                             avatarURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")!,
                                                             token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjcmVuYV9hbGljZSJ9.1w79n48rf9vT-Hn_3qU4-XNtoWr8Yb-kFDe9uFPPDAc",
                                                             birthLand: "India")
    
}

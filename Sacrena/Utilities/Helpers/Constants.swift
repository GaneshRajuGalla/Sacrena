//
//  Constants.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation

typealias DefaultHandler = (() -> ())
typealias GenericHandler<T> = (T?, Error?) -> Void

public let apiKeyString = "c5nva4scz89s"

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

    static let credential: UserCredentials = UserCredentials(id: "tutorial-droid",
                                                       name: "Ganesh Raju Galla",
                                                       avatarURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")!,
                                                       token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYzVudmE0c2N6ODlzIn0.jSY799QRTRrv_3BZcEbvj-s4GD1KvfDne_LOrcEVWIU",
                                                       birthLand: "India")

}

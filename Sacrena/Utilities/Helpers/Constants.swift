//
//  Constants.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//

import Foundation

typealias DefaultHandler = (() -> ())
typealias GenericHandler<T> = (T?, Error?) -> Void

public let apiKeyString = "zcgvnykxsfm8"
public let userId: String = "general_grievous"

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
                                                       token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ2VuZXJhbF9ncmlldm91cyJ9.g2UUZdENuacFIxhYCylBuDJZUZ2x59MTWaSpndWGCTU",
                                                       birthLand: "India")

}

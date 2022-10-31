//
//  AuthLoginBody.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

public struct AuthLoginBody: Encodable {
    let username: String
    let encryptedPassword: String
    let keyID: String
    public init(
        username: String,
        encryptedPassword: String,
        keyID: String
    ) {
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.keyID = keyID
    }
}

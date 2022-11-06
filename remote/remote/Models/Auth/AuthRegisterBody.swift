//
//  AuthRegisterBody.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

public struct AuthRegisterBody: Encodable, Equatable {
    let email: String
    let username: String
    let encryptedPassword: String
    let keyID: String
    
    public init(
        email: String,
        username: String,
        encryptedPassword: String,
        keyID: String
    ) {
        self.email = email
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.keyID = keyID
    }
}

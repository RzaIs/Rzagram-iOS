//
//  AuthRegisterInput.swift
//  domain
//
//  Created by Rza Ismayilov on 08.10.22.
//

public struct AuthRegisterInput: Equatable {
    public let email: String
    public let username: String
    public let password: String
    
    public init(
        email: String,
        username: String,
        password: String
    ) {
        self.email = email
        self.username = username
        self.password = password
    }
}

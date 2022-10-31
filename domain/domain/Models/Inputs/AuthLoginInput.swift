//
//  AuthLoginInput.swift
//  domain
//
//  Created by Rza Ismayilov on 08.10.22.
//

public struct AuthLoginInput {
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

//
//  AuthMockData.swift
//  dataTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import remote
import domain

class AuthMockData {
    static var accessToken: String = "accessToken"
    static var refreshToken: String = "refreshToken"
    static var loginState: Bool = true
    static var encryptedPassword: String = "encryptedPassword"
    
    static var authRemoteDTO: AuthRemoteDTO = .init(
        accessToken: "accessToken",
        refreshToken: "refreshToken"
    )
    static var authPublicKeyDTO: AuthPublicKeyDTO = .init(
        id: "1234567890",
        key: "key123"
    )
    static var authLoginInput: AuthLoginInput = .init(
        username: "username",
        password: "password"
    )
    static var authRegisterInput: AuthRegisterInput = .init(
        email: "email@mail.com",
        username: "username",
        password: "password"
    )
}

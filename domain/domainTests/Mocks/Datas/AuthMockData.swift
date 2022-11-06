//
//  AuthMockData.swift
//  domainTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import domain

class AuthMockData {
    static var loginState: Bool = true
    static var loginInput: AuthLoginInput = .init(
        username: "username",
        password: "password"
    )
    static var registerInput: AuthRegisterInput = .init(
        email: "email@mail.com",
        username: "username",
        password: "password"
    )
}

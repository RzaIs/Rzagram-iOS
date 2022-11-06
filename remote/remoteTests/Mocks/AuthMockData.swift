//
//  AuthMockData.swift
//  remoteTests
//
//  Created by Rza Ismayilov on 06.11.22.
//

@testable import remote

class AuthMockData {
    static var authPublicKeyDTOMock: AuthPublicKeyDTO = .init(
        id: "123456790",
        key: "HDHJFKSNCHDUF"
    )
    static var authRemoteDTOMock: AuthRemoteDTO = .init(
        accessToken: "accessToken",
        refreshToken: "refreshToken"
    )
    static var authLoginBodyMock: AuthLoginBody = .init(
        username: "username",
        encryptedPassword: "hash",
        keyID: "key123"
    )
    static var authRegisterBodyMock: AuthRegisterBody = .init(
        email: "email@mail.com",
        username: "username",
        encryptedPassword: "hash",
        keyID: "key123"
    )
}

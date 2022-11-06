//
//  AuthLocalDataSourceMock.swift
//  dataTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

import local
import Combine

class AuthLocalDataSourceMock: AuthLocalDataSourceProtocol {
    
    var setAccessTokenInput: PassthroughSubject<String, Never> = .init()
    var setRefreshTokenInput: PassthroughSubject<String, Never> = .init()
    var setLoginStateInput: PassthroughSubject<Bool, Never> = .init()
    
    var loginStatePublisher: PassthroughSubject<Bool, Never> = .init()
    
    var setAccessTokenResult: Result<Void, Error> = .success(Void())
    var setRefreshTokenResult: Result<Void, Error> = .success(Void())
    var setLoginStateResult: Result<Void, Error> = .success(Void())
    var removeTokensResult: Result<Void, Error> = .success(Void())

    var accessToken: String? {
        AuthMockData.accessToken
    }
    
    var refreshToken: String? {
        AuthMockData.refreshToken
    }
    
    var loginState: Bool {
        AuthMockData.loginState
    }
    
    var observeLoginState: AnyPublisher<Bool, Never> {
        self.loginStatePublisher.eraseToAnyPublisher()
    }
    
    func set(accessToken: String) throws {
        self.setAccessTokenInput.send(accessToken)
        switch self.setAccessTokenResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func set(refreshToken: String) throws {
        self.setRefreshTokenInput.send(refreshToken)
        switch self.setRefreshTokenResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func set(loginState: Bool) throws {
        self.setLoginStateInput.send(loginState)
        switch self.setLoginStateResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func removeTokens() throws {
        switch self.removeTokensResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
}

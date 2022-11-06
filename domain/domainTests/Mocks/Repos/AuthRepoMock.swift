//
//  AuthRepoMock.swift
//  domainTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import domain
import Combine

class AuthRepoMock: AuthRepoProtocol {
    
    var loginInput: PassthroughSubject<AuthLoginInput, Never> = .init()
    var registerInput: PassthroughSubject<AuthRegisterInput, Never> = .init()
    
    var loginResult: Result<Void, Error> = .success(Void())
    var registerResult: Result<Void, Error> = .success(Void())
    var logoutResult: Result<Void, Error> = .success(Void())
    
    var loginStatePublisher: PassthroughSubject<Bool, Never> = .init()
    
    func login(credentials: AuthLoginInput) async throws {
        self.loginInput.send(credentials)
        switch self.loginResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func register(credentials: AuthRegisterInput) async throws {
        self.registerInput.send(credentials)
        switch self.registerResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func logout() throws {
        switch self.logoutResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    var loginState: Bool {
        AuthMockData.loginState
    }
    
    var observeLoginState: AnyPublisher<Bool, Never> {
        self.loginStatePublisher.eraseToAnyPublisher()
    }
}

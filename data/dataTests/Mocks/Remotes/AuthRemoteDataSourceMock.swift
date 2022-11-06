//
//  AuthRemoteDataSourceMock.swift
//  dataTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

import remote
import Combine

class AuthRemoteDataSourceMock: AuthRemoteDataSourceProtocol {
    
    var loginInput: PassthroughSubject<AuthLoginBody, Never> = .init()
    var registerInput: PassthroughSubject<AuthRegisterBody, Never> = .init()
    
    var getPublicKeyResult: Result<AuthPublicKeyDTO, Error> = .success(AuthMockData.authPublicKeyDTO)
    var loginResult: Result<AuthRemoteDTO, Error> = .success(AuthMockData.authRemoteDTO)
    var registerResult: Result<AuthRemoteDTO, Error> = .success(AuthMockData.authRemoteDTO)
    
    func getPublicKey() async throws -> AuthPublicKeyDTO {
        switch self.getPublicKeyResult {
        case .success(let dto):
            return dto
        case .failure(let error):
            throw error
        }
    }
    
    func login(credentials: AuthLoginBody) async throws -> AuthRemoteDTO {
        self.loginInput.send(credentials)
        switch self.loginResult {
        case .success(let dto):
            return dto
        case .failure(let error):
            throw error
        }
    }
    
    func register(credentials: AuthRegisterBody) async throws -> AuthRemoteDTO {
        self.registerInput.send(credentials)
        switch self.registerResult {
        case .success(let dto):
            return dto
        case .failure(let error):
            throw error
        }
    }
}

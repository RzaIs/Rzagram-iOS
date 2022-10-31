//
//  AuthRepo.swift
//  data
//
//  Created by Rza Ismayilov on 08.10.22.
//

import Combine
import domain
import remote
import local

class AuthRepo: AuthRepoProtocol {
    
    private let authRemoteDataSource: AuthRemoteDataSourceProtocol
    private let authLocalDataSource: AuthLocalDataSourceProtocol
    private let rsaEncryptorProtocol: RSAEncryptorProtocol
    
    init(
        authRemoteDataSource: AuthRemoteDataSourceProtocol,
        authLocalDataSource: AuthLocalDataSourceProtocol,
        rsaEncryptorProtocol: RSAEncryptorProtocol
    ) {
        self.authRemoteDataSource = authRemoteDataSource
        self.authLocalDataSource = authLocalDataSource
        self.rsaEncryptorProtocol = rsaEncryptorProtocol
    }
    
    func login(credentials: AuthLoginInput) async throws {
        var step: Int = 0
        do {
            let publicKey = try await self.authRemoteDataSource.getPublicKey()
            step = 1
            let credentials = try credentials.toRemote(publicKey: publicKey, self.rsaEncryptorProtocol)
            step = 2
            let tokens = try await self.authRemoteDataSource.login(credentials: credentials)
            step = 3
            try self.authLocalDataSource.set(accessToken: tokens.accessToken)
            step = 4
            try self.authLocalDataSource.set(refreshToken: tokens.refreshToken)
            step = 5
            try self.authLocalDataSource.set(loginState: true)
        } catch {
            throw error.toUIError(title: "Login Error", code: "AUTH@1.\(step)")
        }
    }
    
    func register(credentials: AuthRegisterInput) async throws {
        var step: Int = 0
        do {
            let publicKey = try await self.authRemoteDataSource.getPublicKey()
            step = 1
            let credentials = try credentials.toRemote(publicKey: publicKey, self.rsaEncryptorProtocol)
            step = 2
            let tokens = try await self.authRemoteDataSource.register(credentials: credentials)
            step = 3
            try self.authLocalDataSource.set(accessToken: tokens.accessToken)
            step = 4
            try self.authLocalDataSource.set(refreshToken: tokens.refreshToken)
            step = 5
            try self.authLocalDataSource.set(loginState: true)
        } catch {
            throw error.toUIError(title: "Login Error", code: "AUTH@2.\(step)")
        }
    }
    
    func logout() throws {
        var step: Int = 0
        do {
            try self.authLocalDataSource.removeTokens()
            step = 1
            try self.authLocalDataSource.set(loginState: false)
        } catch {
            throw error.toUIError(title: "Logout Error", code: "AUTH@3.\(step)")
        }
    }
    
    var loginState: Bool {
        self.authLocalDataSource.loginState
    }
    
    var observeLoginState: AnyPublisher<Bool, Never> {
        self.authLocalDataSource.observeLoginState
    }

}

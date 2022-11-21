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
    
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let localDataSource: AuthLocalDataSourceProtocol
    private let rsaEncryptor: RSAEncryptorProtocol
    
    init(
        remoteDataSource: AuthRemoteDataSourceProtocol,
        localDataSource: AuthLocalDataSourceProtocol,
        rsaEncryptor: RSAEncryptorProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.rsaEncryptor = rsaEncryptor
    }
    
    func login(credentials: AuthLoginInput) async throws {
        var step: Int = 0
        do {
            let publicKey = try await self.remoteDataSource.getPublicKey()
            step = 1
            let credentials = try credentials.toRemote(publicKey: publicKey, self.rsaEncryptor)
            step = 2
            let tokens = try await self.remoteDataSource.login(credentials: credentials)
            step = 3
            try self.localDataSource.set(accessToken: tokens.accessToken)
            step = 4
            try self.localDataSource.set(refreshToken: tokens.refreshToken)
            step = 5
            try self.localDataSource.set(loginState: true)
        } catch {
            throw error.toUIError(title: "Login Error", code: "AUTH@1.\(step)")
        }
    }
    
    func register(credentials: AuthRegisterInput) async throws {
        var step: Int = 0
        do {
            let publicKey = try await self.remoteDataSource.getPublicKey()
            step = 1
            let credentials = try credentials.toRemote(publicKey: publicKey, self.rsaEncryptor)
            step = 2
            let tokens = try await self.remoteDataSource.register(credentials: credentials)
            step = 3
            try self.localDataSource.set(accessToken: tokens.accessToken)
            step = 4
            try self.localDataSource.set(refreshToken: tokens.refreshToken)
            step = 5
            try self.localDataSource.set(loginState: true)
        } catch {
            throw error.toUIError(title: "Register Error", code: "AUTH@2.\(step)")
        }
    }
    
    func logout() throws {
        var step: Int = 0
        do {
            try self.localDataSource.removeTokens()
            step = 1
            try self.localDataSource.set(loginState: false)
        } catch {
            throw error.toUIError(title: "Logout Error", code: "AUTH@3.\(step)")
        }
    }
    
    var loginState: Bool {
        self.localDataSource.loginState
    }
    
    var observeLoginState: AnyPublisher<Bool, Never> {
        self.localDataSource.observeLoginState
    }

}

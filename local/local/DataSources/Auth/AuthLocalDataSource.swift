//
//  AuthLocalDataSource.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Combine

class AuthLocalDataSource: AuthLocalDataSourceProtocol {

    private let loginSubject: CurrentValueSubject<Bool, Never>
    private let databaseProvider: DatabaseProviderProtocol
    
    init(databaseProvider: DatabaseProviderProtocol) {
        self.databaseProvider = databaseProvider
        self.loginSubject = .init(
            databaseProvider.getSafeCache(key: .loginState) ?? false
        )
    }
    
    var accessToken: String? {
        self.databaseProvider.getSafeCache(key: .accessToken)
    }
    
    var refreshToken: String? {
        self.databaseProvider.getSafeCache(key: .refreshToken)
    }
    
    var loginState: Bool {
        self.databaseProvider.getSafeCache(key: .loginState) ?? false
    }
    
    var observeLoginState: AnyPublisher<Bool, Never> {
        self.loginSubject.eraseToAnyPublisher()
    }
    
    func set(accessToken: String) throws {
        try self.databaseProvider.cacheSafe(data: accessToken, key: .accessToken)
    }
    
    func set(refreshToken: String) throws {
        try self.databaseProvider.cacheSafe(data: refreshToken, key: .refreshToken)
    }
    
    func set(loginState: Bool) throws {
        try self.databaseProvider.cacheSafe(data: loginState, key: .loginState)
        self.loginSubject.send(loginState)
    }
    
    func removeTokens() throws {
        try self.databaseProvider.deleteSafeCache(key: .accessToken)
        try self.databaseProvider.deleteSafeCache(key: .refreshToken)
    }
}

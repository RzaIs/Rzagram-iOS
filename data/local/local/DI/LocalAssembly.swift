//
//  LocalAssembly.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Swinject
import Realm
import RealmSwift
import KeychainAccess
import global

public class LocalAssembly: Assembly {
    
    private let keychainService: String
    
    public init(keychainService: String) {
        self.keychainService = keychainService
    }
    
    
    public func assemble(container: Container) {
        
        // Realm & Keychain
        
        container.register(Realm.self) { r in
            try! Realm(
                configuration: Realm.Configuration(
                    schemaVersion: 0,
                    deleteRealmIfMigrationNeeded: true
                )
            )
        }.inObjectScope(.container)
        
        container.register(Keychain.self) { r in
            Keychain(service: self.keychainService)
        }.inObjectScope(.container)
        
        container.register(DatabaseProviderProtocol.self) { r in
            DatabaseProvider(
                realm: r.resolve(Realm.self)!,
                keychain: r.resolve(Keychain.self)!
            )
        }.inObjectScope(.container)
        
        container.register(AuthLocalDataSourceProtocol.self) { r in
            AuthLocalDataSource(databaseProvider: r.resolve(DatabaseProviderProtocol.self)!)
        }.inObjectScope(.container)
        
        let getRefreshTokenFunc = (() -> String?).self
        container.register(getRefreshTokenFunc.self, name: AuthInjectionKeys.getAccessToken.rawValue) { r in
            let authLocalDataSource = r.resolve(AuthLocalDataSourceProtocol.self)!
            return {
                authLocalDataSource.accessToken
            }
        }
        
        let setAccessTokenFunc = ((String) throws -> Void).self
        container.register(setAccessTokenFunc.self, name: AuthInjectionKeys.setAccessToken.rawValue) { r in
            let authLocalDataSource = r.resolve(AuthLocalDataSourceProtocol.self)!
            return { token in
                try authLocalDataSource.set(accessToken: token)
            }
        }
        
        let setRefreshTokenFunc = ((String) throws -> Void).self
        container.register(setRefreshTokenFunc.self, name: AuthInjectionKeys.setRefreshToken.rawValue) { r in
            let authLocalDataSource = r.resolve(AuthLocalDataSourceProtocol.self)!
            return { token in
                try authLocalDataSource.set(refreshToken: token)
            }
        }
    }
}

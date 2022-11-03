//
//  LocalInject.swift
//  local
//
//  Created by Rza Ismayilov on 03.11.22.
//

import domain
import Realm
import RealmSwift
import KeychainAccess

public class LocalInject: BaseInject<EmptyDependency> {
    
    private let keychainService: String
    
    public init(keychainService: String) {
        self.keychainService = keychainService
        super.init(dependency: EmptyDependency())
    }
    
    lazy var realm: Realm = try! Realm(
        configuration: Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true
        )
    )
    
    lazy var keychain: Keychain = .init(service: self.keychainService)
 
    lazy var databaseProvider: DatabaseProviderProtocol = DatabaseProvider(
        realm: self.realm,
        keychain: self.keychain
    )
    
    public lazy var authLocalDataSource: AuthLocalDataSourceProtocol = AuthLocalDataSource(databaseProvider: self.databaseProvider)
}

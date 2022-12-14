//
//  LocalInject.swift
//  local
//
//  Created by Rza Ismayilov on 03.11.22.
//

import Inject
import Realm
import RealmSwift
import KeychainAccess
import domain

public class LocalInject: Inject<EmptyDependency> {
    
    private let keychainService: String
    
    public init(keychainService: String) {
        self.keychainService = keychainService
        super.init()
    }
    
    lazy var realm: Realm = try! Realm(
        configuration: Realm.Configuration(
            schemaVersion: 0,
            deleteRealmIfMigrationNeeded: true
        )
    )
    
    lazy var keychain: Keychain = {
        Keychain(service: self.keychainService)
    }()
 
    lazy var databaseProvider: DatabaseProviderProtocol = {
        DatabaseProvider(
            realm: self.realm,
            keychain: self.keychain
        )
    }()
    
    public lazy var authLocalDataSource: AuthLocalDataSourceProtocol = {
        AuthLocalDataSource(databaseProvider: self.databaseProvider)
    }()
        
    public lazy var postLocalDataSource: PostLocalDataSourceProtocol = {
        PostLocalDataSource(databaseProvider: self.databaseProvider)
    }()
}

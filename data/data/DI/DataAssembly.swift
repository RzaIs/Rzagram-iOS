//
//  DataAssembly.swift
//  data
//
//  Created by Rza Ismayilov on 08.10.22.
//

import domain
import remote
import local
import Swinject
import Realm
import RealmSwift
import KeychainAccess


public class DataAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RSAEncryptorProtocol.self) { r in
            RSAEncryptor()
        }
        
        container.register(AuthRepoProtocol.self) { r in
            AuthRepo(
                authRemoteDataSource: r.resolve(AuthRemoteDataSourceProtocol.self)!,
                authLocalDataSource: r.resolve(AuthLocalDataSourceProtocol.self)!,
                rsaEncryptorProtocol: r.resolve(RSAEncryptorProtocol.self)!
            )
        }
    }
}

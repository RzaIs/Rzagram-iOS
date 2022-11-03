//
//  DataInject.swift
//  data
//
//  Created by Rza Ismayilov on 03.11.22.
//

import domain
import remote
import local

public class DataInject: BaseInject<EmptyDependency>, DomainDependency {
    
    private let baseURL: String
    private let keychainService: String
    
    public init(baseURL: String, keychainService: String) {
        self.baseURL = baseURL
        self.keychainService = keychainService
        super.init(dependency: EmptyDependency())
    }
    
    public lazy var remoteInject: RemoteInject = RemoteInject(
        baseURL: self.baseURL,
        dependency: self
    )
    
    public lazy var localInject: LocalInject = LocalInject(
        keychainService: self.keychainService
    )
    
    var rsaEncryptor: RSAEncryptorProtocol {
        RSAEncryptor()
    }
    
    public var authRepo: AuthRepoProtocol {
        AuthRepo(
            authRemoteDataSource: self.remoteInject.authRemoteDataSource,
            authLocalDataSource: self.localInject.authLocalDataSource,
            rsaEncryptorProtocol: self.rsaEncryptor
        )
    }
}

extension DataInject: RemoteDependency {
    public var getAccessToken: () -> String? {
        {
             self.localInject.authLocalDataSource.accessToken
        }
    }
    
    public var getRefreshToken: () -> String? {
        {
            self.localInject.authLocalDataSource.refreshToken
        }
    }
    
    public var setAccessToken: (String) throws -> Void {
        { token in
            try self.localInject.authLocalDataSource.set(accessToken: token)
        }
    }
    
    public var setRefreshToken: (String) throws -> Void {
        { token in
            try self.localInject.authLocalDataSource.set(refreshToken: token)
        }
    }
}

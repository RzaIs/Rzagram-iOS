//
//  DataInject.swift
//  data
//
//  Created by Rza Ismayilov on 03.11.22.
//

import Inject
import domain
import remote
import local

public class DataInject: Inject<EmptyDependency>, DomainDependency {
    
    private let baseURL: String
    private let keychainService: String
    
    public init(baseURL: String, keychainService: String) {
        self.baseURL = baseURL
        self.keychainService = keychainService
        super.init()
    }
    
    public lazy var remoteInject: RemoteInject = {
        RemoteInject(
            baseURL: self.baseURL,
            dependency: self
        )
    }()
    
    public lazy var localInject: LocalInject = {
        LocalInject(keychainService: self.keychainService)
    }()
    
    var rsaEncryptor: RSAEncryptorProtocol {
        RSAEncryptor()
    }
    
    public var authRepo: AuthRepoProtocol {
        AuthRepo(
            remoteDataSource: self.remoteInject.authRemoteDataSource,
            localDataSource: self.localInject.authLocalDataSource,
            rsaEncryptor: self.rsaEncryptor
        )
    }
    
    public var postRepo: PostRepoProtocol {
        PostRepo(
            remoteDataSource: self.remoteInject.postRemoteDataSource,
            localDataSource: self.localInject.postLocalDataSource
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
        self.localInject.authLocalDataSource.set(accessToken:)
    }
    
    public var setRefreshToken: (String) throws -> Void {
        self.localInject.authLocalDataSource.set(refreshToken:)
    }
    
    public var expireSession: () throws -> Void {
        {
            try self.localInject.authLocalDataSource.set(loginState: false)
            try self.localInject.authLocalDataSource.removeTokens()
        }
    }
}

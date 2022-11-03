//
//  AuthRemoteDataSource.swift
//  remote
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Alamofire

class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func getPublicKey() async throws -> AuthPublicKeyDTO {
        try await self.networkProvider.get(
            endpoint: AuthAPI.key.rawValue,
            method: .get,
            headers: .default
        )
    }
    
    func login(credentials: AuthLoginBody) async throws -> AuthRemoteDTO {
        try await self.networkProvider.request(
            endpoint: AuthAPI.login.rawValue,
            method: .post,
            headers: .default,
            encoder: JSONParameterEncoder.default,
            parameters: credentials
        )
    }
    
    func register(credentials: AuthRegisterBody) async throws -> AuthRemoteDTO {
        try await self.networkProvider.request(
            endpoint: AuthAPI.register.rawValue,
            method: .post,
            headers: .default,
            encoder: JSONParameterEncoder.default,
            parameters: credentials
        )
    }
}

//
//  AuthRemoteDataSourceProtocol.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

public protocol AuthRemoteDataSourceProtocol {
    func getPublicKey() async throws -> AuthPublicKeyDTO
    func login(credentials: AuthLoginBody) async throws -> AuthRemoteDTO
    func register(credentials: AuthRegisterBody) async throws -> AuthRemoteDTO
}

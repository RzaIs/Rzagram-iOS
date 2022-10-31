//
//  AuthRepoProtocol.swift
//  domain
//
//  Created by Rza Ismayilov on 08.10.22.
//

import Combine

public protocol AuthRepoProtocol {
    func login(credentials: AuthLoginInput) async throws
    func register(credentials: AuthRegisterInput) async throws
    func logout() throws
    var loginState: Bool { get }
    var observeLoginState: AnyPublisher<Bool, Never> { get }
}

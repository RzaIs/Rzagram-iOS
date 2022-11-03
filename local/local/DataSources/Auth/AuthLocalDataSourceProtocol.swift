//
//  AuthLocalDataSourceProtocol.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Combine

public protocol AuthLocalDataSourceProtocol {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var loginState: Bool { get }
    var observeLoginState: AnyPublisher<Bool, Never> { get }

    func set(accessToken: String) throws
    func set(refreshToken: String) throws
    func set(loginState: Bool) throws
    func removeTokens() throws
}

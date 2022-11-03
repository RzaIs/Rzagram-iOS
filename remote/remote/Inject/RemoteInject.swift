//
//  RemoteInject.swift
//  remote
//
//  Created by Rza Ismayilov on 03.11.22.
//

import domain

public protocol RemoteDependency {
    var getAccessToken: () -> String? { get }
    var getRefreshToken: () -> String? { get }
    var setAccessToken: (String) throws -> Void { get }
    var setRefreshToken: (String) throws -> Void { get }
}

public class RemoteInject: BaseInject<RemoteDependency> {
    
    private let baseURL: String

    public init(baseURL: String, dependency: RemoteDependency) {
        self.baseURL = baseURL
        super.init(dependency: dependency)
    }

    var logger: Logger {
        Logger()
    }

    var authAdapter: AuthAdapter {
        AuthAdapter(getAccessToken: self.dependency.getAccessToken)
    }
    
    var authRetrier: AuthRetrier {
        AuthRetrier(
            baseURL: self.baseURL,
            getRefreshToken: self.dependency.getRefreshToken,
            setAccessToken: self.dependency.setAccessToken,
            setRefreshToken: self.dependency.setRefreshToken
        )
    }
    
    var networkProvider: NetworkProviderProtocol {
        NetworkProvider(
            baseURL: self.baseURL,
            logger: self.logger,
            adapters: [
                self.logger,
                self.authAdapter
            ],
            retriers: [
                self.authRetrier
            ]
        )
    }
    
    public var authRemoteDataSource: AuthRemoteDataSourceProtocol {
        AuthRemoteDataSource(networkProvider: self.networkProvider)
    }
}

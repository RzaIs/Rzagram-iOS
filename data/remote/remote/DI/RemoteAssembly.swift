//
//  RemoteAssembly.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

import Swinject
import global

public class RemoteAssembly: Assembly {
    
    private let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func assemble(container: Container) {
        container.register(Logger.self) { r in
            Logger()
        }
        
        container.register(AuthAdapter.self) { r in
            let getRefreshTokenFunc = (() -> String?).self
            
            return AuthAdapter(
                getAccessToken: r.resolve(
                    getRefreshTokenFunc.self,
                    name: AuthInjectionKeys.getAccessToken.rawValue
                )!
            )
        }
        
        container.register(AuthRetrier.self) { r in
            
            let getRefreshTokenFunc = (() -> String?).self
            let setAccessTokenFunc = ((String) throws -> Void).self
            let setRefreshTokenFunc = ((String) throws -> Void).self
            
            return AuthRetrier(
                baseURL: self.baseURL,
                getRefreshToken: r.resolve(
                    getRefreshTokenFunc.self,
                    name: AuthInjectionKeys.getAccessToken.rawValue
                )!,
                setAccessToken: r.resolve(
                    setAccessTokenFunc.self,
                    name: AuthInjectionKeys.setAccessToken.rawValue
                )!,
                setRefreshToken: r.resolve(
                    setRefreshTokenFunc.self,
                    name: AuthInjectionKeys.setRefreshToken.rawValue
                )!
            )
        }
        
        container.register(NetworkProviderProtocol.self) { r in
            NetworkProvider(
                baseURL: self.baseURL,
                logger: r.resolve(Logger.self)!,
                adapters: [
                    r.resolve(Logger.self)!,
                    r.resolve(AuthAdapter.self)!
                ],
                retriers: [
                    r.resolve(AuthRetrier.self)!
                ]
            )
        }
        
        container.register(AuthRemoteDataSourceProtocol.self) { r in
            AuthRemoteDataSource(networkProvider: r.resolve(NetworkProviderProtocol.self)!)
        }
    }
}

//
//  DomainAssembly.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Swinject

public class DomainAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(AuthLoginUseCase.self) { r in
            AuthLoginUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthRegisterUseCase.self) { r in
            AuthRegisterUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthLogoutUseCase.self) { r in
            AuthLogoutUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthObserveLoginState.self) { r in
            AuthObserveLoginState(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthGetLoginState.self) { r in
            AuthGetLoginState(repo: r.resolve(AuthRepoProtocol.self)!)
        }
    }
}

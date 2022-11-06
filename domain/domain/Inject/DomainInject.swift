//
//  DomainInject.swift
//  domain
//
//  Created by Rza Ismayilov on 03.11.22.
//

import Inject

public protocol DomainDependency {
    var authRepo: AuthRepoProtocol { get }
}

public class DomainInject: Inject<DomainDependency> {
    
    public var authLoginUseCase: AuthLoginUseCase {
        AuthLoginUseCase(repo: self.dependency.authRepo)
    }
    
    public var authRegisterUseCase: AuthRegisterUseCase {
        AuthRegisterUseCase(repo: self.dependency.authRepo)
    }
    
    public var authObserveLoginState: AuthObserveLoginStateUseCase {
        AuthObserveLoginStateUseCase(repo: self.dependency.authRepo)
    }
    
    public var authGetLoginState: AuthGetLoginStateUseCase {
        AuthGetLoginStateUseCase(repo: self.dependency.authRepo)
    }
    
    public var authLogoutUseCase: AuthLogoutUseCase {
        AuthLogoutUseCase(repo: self.dependency.authRepo)
    }
}

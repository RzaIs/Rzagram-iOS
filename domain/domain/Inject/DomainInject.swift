//
//  DomainInject.swift
//  domain
//
//  Created by Rza Ismayilov on 03.11.22.
//

public protocol DomainDependency {
    var authRepo: AuthRepoProtocol { get }
}

public class DomainInject: BaseInject<DomainDependency> {
    
    public var authLoginUseCase: AuthLoginUseCase {
        AuthLoginUseCase(repo: self.dependency.authRepo)
    }
    
    public var authRegisterUseCase: AuthRegisterUseCase {
        AuthRegisterUseCase(repo: self.dependency.authRepo)
    }
    
    public var authObserveLoginState: AuthObserveLoginState {
        AuthObserveLoginState(repo: self.dependency.authRepo)
    }
    
    public var authGetLoginState: AuthGetLoginState {
        AuthGetLoginState(repo: self.dependency.authRepo)
    }
    
    public var authLogoutUseCase: AuthLogoutUseCase {
        AuthLogoutUseCase(repo: self.dependency.authRepo)
    }
}

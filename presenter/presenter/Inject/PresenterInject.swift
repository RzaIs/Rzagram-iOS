//
//  PresenterInject.swift
//  presenter
//
//  Created by Rza Ismayilov on 03.11.22.
//

import domain

public class PresenterInject: BaseInject<EmptyDependency> {
    private  var domainInject: DomainInject
    
    public init(domainInject: DomainInject) {
        self.domainInject = domainInject
        super.init(dependency: EmptyDependency())
    }
    
    var router: RouterProtocol {
        Router(inject: self)
    }
    
    var mainService: MainService {
        MainService(
            authGetLoginState: self.domainInject.authGetLoginState,
            authObserveLoginState: self.domainInject.authObserveLoginState,
            authLogoutUseCase: self.domainInject.authLogoutUseCase
        )
    }
    
    public var mainPage: MainPage {
        MainPage(
            router: self.router,
            service: self.mainService
        )
    }
    
    var authService: AuthService {
        AuthService(
            authLoginUseCase: self.domainInject.authLoginUseCase,
            authRegisterUseCase: self.domainInject.authRegisterUseCase
        )
    }
    
    var authPage: AuthPage {
        AuthPage(
            router: self.router,
            service: self.authService
        )
    }
}

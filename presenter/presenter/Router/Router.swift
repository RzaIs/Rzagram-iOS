//
//  Router.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Swinject
import domain

class Router: RouterProtocol {
    private let r: Resolver
    
    init(resolver: Resolver) {
        self.r = resolver
    }
    
    var mainPage: MainPage {
        self.r.resolve(MainPage.self)!
    }

    var authPage: AuthPage {
        self.r.resolve(AuthPage.self)!
    }
}

#if DEBUG

class RouterMock: RouterProtocol {
    
    static let router: RouterMock = .init()
    
    
    var authGetLoginStateValue: Bool = false
    var authObserveLoginStateValue: Bool = false
    var mainPage: MainPage {
        MainPage(
            router: RouterMock.router,
            service: MainService(
                authGetLoginState: AuthGetLoginStateMock(value: authGetLoginStateValue),
                authObserveLoginState: AuthObserveLoginStateMock(value: authObserveLoginStateValue),
                authLogoutUseCase: AuthLogoutUseCaseMock()
            )
        )
    }
    
    var authPage: AuthPage {
        AuthPage(
            router: RouterMock.router,
            service: AuthService(
                authLoginUseCase: AuthLoginUseCaseMock(),
                authRegisterUseCase: AuthRegisterUseCaseMock()
            )
        )
    }
}

#endif

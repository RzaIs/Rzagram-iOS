//
//  Router.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Swinject
import domain

class Router: RouterProtocol {
    private let inject: PresenterInject
    
    init(inject: PresenterInject) {
        self.inject = inject
    }
    
    var mainPage: MainPage {
        self.inject.mainPage
    }

    var authPage: AuthPage {
        self.inject.authPage
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

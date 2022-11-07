//
//  RouterMock.swift
//  presenter
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

import domain

class RouterMock: RouterProtocol {
    
    static let router: RouterMock = .init()
    
    var authGetLoginStateValue: Bool = false
    var authObserveLoginStateValue: Bool = false
    var mainPage: MainPage {
        MainPage(
            router: RouterMock.router,
            service: MainService(
                authGetLoginStateUseCase: AuthGetLoginStateUseCaseMock(value: authGetLoginStateValue),
                authObserveLoginStateUseCase: AuthObserveLoginStateUseCaseMock(value: authObserveLoginStateValue),
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

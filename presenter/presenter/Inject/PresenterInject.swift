//
//  PresenterInject.swift
//  presenter
//
//  Created by Rza Ismayilov on 03.11.22.
//

import Inject
import domain

public class PresenterInject: Inject<DomainInject> {
        
    var router: RouterProtocol {
        Router(inject: self)
    }
    
    var mainService: MainService {
        MainService(
            authGetLoginState: self.dependency.authGetLoginState,
            authObserveLoginState: self.dependency.authObserveLoginState,
            authLogoutUseCase: self.dependency.authLogoutUseCase
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
            authLoginUseCase: self.dependency.authLoginUseCase,
            authRegisterUseCase: self.dependency.authRegisterUseCase
        )
    }
    
    var authPage: AuthPage {
        AuthPage(
            router: self.router,
            service: self.authService
        )
    }
}

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
            authGetLoginStateUseCase: self.dependency.authGetLoginState,
            authObserveLoginStateUseCase: self.dependency.authObserveLoginState,
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
    
    var homeService: HomeService {
        HomeService(
            postGetAndCacheUseCase: self.dependency.postGetAndCacheUseCase,
            postGetManyUseCase: self.dependency.postGetManyUseCase,
            postGetCacheUseCase: self.dependency.postGetCacheUseCase
        )
    }
    
    var homePage: HomePage {
        HomePage(
            router: self.router,
            service: self.homeService
        )
    }
}
